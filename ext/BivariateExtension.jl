module BivariateExtension

using SpeciesDistributionToolkit
import SpeciesDistributionToolkit: bivariate, bivariate!, ArcMapOrangeBlue, StevensRedVlue, StevensBluePurple, StevensBlueGreen, StevensYellowPurple
using Makie

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

end