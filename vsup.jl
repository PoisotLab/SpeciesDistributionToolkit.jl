using Revise
using CairoMakie
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit

pol = getpolygon(PolygonData(OpenStreetMap, Places); place = "Corsica");
spatialextent = SDT.boundingbox(pol; padding = 0.1)

# some layers

provider = RasterData(CHELSA2, BioClim)
L = SDMLayer{Float16}[
    SDMLayer(
        provider;
        layer = i,
        spatialextent...,
    ) for i in layers(provider)
]

mask!(L, pol)

# Model
model = SDM(RawData, Logistic, SDeMo.__demodata()...)
variables!(model, ForwardSelection)
predict(model, L; threshold = false) |> heatmap

ens = Bagging(model, 50)
bagfeatures!(ens)
train!(ens)

# unpack

val = predict(model, L; threshold = false)
unc = predict(ens, L; threshold = false, consensus = iqr)

# RECIPE

function discretize(layer, n::Integer)
    categories = rescale(layer, 0.0, 1.0)
    map!(x -> round(x * (n - 1); digits = 0) / (n - 1), categories.grid, categories.grid)
    map!(x -> x * (n - 1) + 1, categories.grid, categories.grid)
    return convert(SDMLayer{Int}, categories)
end

function _vsup_grid(vbins, ubins, vpal; upal = colorant"#ffffff", s = 0.5, k = 1.0)
    pal = fill(upal, (vbins, ubins))
    for i in 1:ubins
        shrkfac = ((i - 1) / (ubins - 1))^k
        subst = 0.5 - shrkfac * s / 2
        pal[:, i] .= Makie.cgrad(vpal)[LinRange(0.5 - subst, 0.5 + subst, vbins)]
        # Apply the mix to the uncertain color
        for j in 1:vbins
            pal[j, i] = Makie.ColorSchemes.weighted_color_mean(1 - shrkfac, pal[j, i], upal)
        end
    end
    return pal
end

function _multiply(c1::Makie.ColorTypes.RGB, c2::Makie.ColorTypes.RGB)
    return Makie.ColorTypes.RGBA(
        (c1.r * c2.r),
        (c1.g * c2.g),
        (c1.b * c2.b),
        1.0,
    )
end

function _multiply(c1::Makie.ColorTypes.RGBA, c2::Makie.ColorTypes.RGBA)
    return Makie.ColorTypes.RGBA(
        (c1.r * c2.r),
        (c1.g * c2.g),
        (c1.b * c2.b),
        (c1.alpha + c2.alpha)/2,
    )
end

function _multiply(c1::Makie.ColorTypes.RGBA, c2::Makie.ColorTypes.RGB)
    return Makie.ColorTypes.RGBA(
        (c1.r * c2.r),
        (c1.g * c2.g),
        (c1.b * c2.b),
        c1.alpha/2,
    )
end

_multiply(c1::Makie.ColorTypes.RGB, c2::Makie.ColorTypes.RGBA) = _multiply(c2, c1)

function _bivariate_grid(xbins, ybins, xcm, ycm)
    cx = Makie.cgrad(xcm, xbins; categorical = true)
    cy = Makie.cgrad(ycm, ybins; categorical = true)
    return [_multiply.(x, y) for x in cx, y in cy]
end

Makie.@recipe Bivariate (x, y) begin
    xcolormap = [colorant"#e8e8e8", colorant"#73ae80"]
    ycolormap = [colorant"#e8e8e8", colorant"#6c83b5"]
    xbins = 3
    ybins = 3
end

Makie.plottype(::Bivariate) = CellGrid
Makie.convert_arguments(::Type{Bivariate}, x::SDMLayer, y::SDMLayer) =
    (x, y)

function Makie.plot!(bv::Bivariate)
    # First, we get the palette with increasing amounts of masking
    newpal = _bivariate_grid(
        bv.xbins[],
        bv.ybins[],
        bv.xcolormap[],
        bv.ycolormap[],
    )

    # Next, we turn each layer into a binarized version
    xbin = discretize(bv.x[], bv.xbins[])
    ybin = discretize(bv.y[], bv.ybins[])

    # And then we assemble the layer to plot
    idx = LinearIndices(newpal)

    pal_position = similar(bv.x[], Int)
    for k in keys(pal_position)
        pal_position[k] = idx[xbin[k], ybin[k]]
    end

    # And this makes the plot we need
    heatmap!(bv, pal_position; colormap = vec(newpal), colorrange = extrema(idx))

    return bv
end

bivariate(L[1], L[12]; ESRIOrangeBlue()...)

StevensRedBlue() = (
    xcolormap = [colorant"#e8e8e8", colorant"#c85a5a"],
    ycolormap = [colorant"#e8e8e8", colorant"#64acbe"],
)
StevensBluePurple() = (
    xcolormap = [colorant"#e8e8e8", colorant"#5ac8c8"],
    ycolormap = [colorant"#e8e8e8", colorant"#be64ac"],
)
StevensBlueGreen() = (
    xcolormap = [colorant"#e8e8e8", colorant"#6c83b5"],
    ycolormap = [colorant"#e8e8e8", colorant"#73ae80"],
)
StevensYellowPurple() = (
    xcolormap = [colorant"#e8e8e8", colorant"#c8b35a"],
    ycolormap = [colorant"#e8e8e8", colorant"#9972af"],
)

ArcMapOrangeBlue() = (
    xcolormap = [colorant"#f2f2f5", colorant"#f4b303"],
    ycolormap = [colorant"#f2f2f5", colorant"#519cc5"],
)

f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
vs = bivariate!(ax, val, unc; xbins = 5, ybins = 5, ArcMapOrangeBlue()...)
current_figure()

# VSUP

Makie.@recipe VSUP (value, uncertainty) begin
    uncertaincolor = colorant"#ffffff"
    colormap = @inherit colormap
    valuebins = 6
    uncertaintybins = 5
end

Makie.convert_arguments(::Type{VSUP}, value::SDMLayer, uncertainty::SDMLayer) =
    (value, uncertainty)
Makie.plottype(::VSUP) = CellGrid

function Makie.plot!(vs::VSUP)
    # First, we get the palette with increasing amounts of masking
    newpal = _vsup_grid(
        vs.valuebins[],
        vs.uncertaintybins[],
        vs.colormap[];
        upal = vs.uncertaincolor[],
    )

    # Next, we turn each layer into a binarized version
    v_bin = discretize(vs.value[], vs.valuebins[])
    u_bin = discretize(vs.uncertainty[], vs.uncertaintybins[])

    # And then we assemble the layer to plot
    idx = LinearIndices(newpal)
    pal_position = similar(vs.value[], Int)
    for k in keys(pal_position)
        pal_position[k] = idx[v_bin[k], u_bin[k]]
    end

    # And this makes the plot we need
    heatmap!(vs, pal_position; colormap = vec(newpal), colorrange = extrema(idx))
    return vs
end