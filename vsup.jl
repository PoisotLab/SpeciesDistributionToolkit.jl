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

Makie.@recipe VSUP (value, uncertainty) begin
    uncertaincolor = colorant"#ffffff"
    colormap = @inherit colormap
    valuebins = 6
    uncertaintybins = 5
end

Makie.@recipe VSUPLegend (vs::VSUP,) begin
    span = π / 2
    orientation = π
end

Makie.convert_arguments(::Type{VSUP}, value::SDMLayer, uncertainty::SDMLayer) =
    (value, uncertainty)
Makie.plottype(::VSUP) = CellGrid

# We will lift the arguments for the legend
const VSUPlot{V,U} = Plot{vsup, Tuple{SDMLayer{V}, SDMLayer{U}}}
Makie.convert_arguments(::Type{VSUPLegend}, vs::VSUPlot{U,V}) where {U,V} = (vs,)
Makie.preferred_axis_type(::VSUPLegend) = Makie.PolarAxis
Makie.plottype(::VSUPLegend) = Surface

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

function Makie.plot!(vl::VSUPLegend)
    @info "lol"
    @info vl.args[]
    surface!(vl,
        -π / 4 .. π / 4,
        0 .. 1,
        zeros(Float64, (5, 5));
        shading = NoShading,
    )
    return vl
end

vsuplegend(vs)

f = Figure()
ax = Axis(f[1, 1]; aspect = DataAspect())
vs = vsup!(
    ax,
    val,
    unc;
    colormap = :thermal,
    valuebins = 20,
    uncertaintybins = 15,
    uncertaincolor = colorant"#f0f0f0",
)
current_figure()

# temperature layer

# fig-hm
heatmap(val; axis = (aspect = DataAspect(),))
lines!(pol; color = :black)
current_figure() #hide

# now see the seasonality layer

# fig-hm-unc
heatmap(unc; axis = (aspect = DataAspect(),))
lines!(pol; color = :black)
current_figure() #hide

ax_inset = PolarAxis(f[1, 1];
    width = Relative(0.25),
    height = Relative(0.5),
    halign = 0.0,
    valign = 0.0,
    theta_0 = pi,
    direction = -1,
    tellheight = false,
    tellwidth = false,
    rgridvisible = false,
    thetagridvisible = false,
)

surface!(
    ax_inset,
    -π / 4 .. π / 4,
    0 .. 1,
    zeros(size(pal));
    color = reverse(pal),
    shading = NoShading,
)
thetalims!(ax_inset, -pi / 4, pi / 4)
rlims!(ax_inset, 0.1, 1)
current_figure() #hide
