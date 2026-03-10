module VSUPExtension

using SpeciesDistributionToolkit
import SpeciesDistributionToolkit: vsup, vsup!, vsuplegend, vsuplegend!
using Makie

function _merge_by(collection, n)
    groups = Base.Iterators.partition(collection, n)
    grouped = map(x -> Makie.ColorSchemes.weighted_color_mean(ones(n) / n, x), groups)
    return repeat(grouped; inner = n)
end

function _vsup_grid(bins, colormap, color)
    vbins = 2^(bins - 1)
    pal = fill(color, (vbins, bins))
    for i in 1:bins
        shrkfac = ((i - 1) / (bins - 1))
        row_pal = _merge_by(Makie.cgrad(colormap, vbins; categorical = true), 2^(i - 1))
        pal[:, i] .= row_pal
        for j in 1:vbins
            pal[j, i] =
                Makie.ColorSchemes.weighted_color_mean(1 - shrkfac, pal[j, i], color)
        end
    end
    return pal
end

# VSUP

function _shared_vsup_attributes()
    Makie.@DocumentedAttributes begin
        color = colorant"#e8e8e8"
        colormap = @inherit colormap
        bins = 5
    end
end

Makie.@recipe VSUP (value, uncertainty) begin
    _shared_vsup_attributes()...
end

Makie.convert_arguments(::Type{VSUP}, value::SDMLayer, uncertainty::SDMLayer) =
    (value, uncertainty)
Makie.plottype(::VSUP) = CellGrid

function Makie.plot!(vs::VSUP)

    # Value bins
    valuebins = 2^(vs.bins[] - 1)

    # First, we get the palette with increasing amounts of masking
    newpal = _vsup_grid(
        vs.bins[],
        vs.colormap[],
        vs.color[],
    )

    # Next, we turn each layer into a binarized version
    v_bin = discretize(vs.value[], valuebins)
    u_bin = discretize(vs.uncertainty[], vs.bins[])

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

Makie.@recipe VSUPLegend (vs, ) begin
    _shared_vsup_attributes()...
    direction = 0
    span = π / 3
end

Makie.convert_arguments(::Type{VSUPLegend}, value::SDMLayer, uncertainty::SDMLayer) =
    (value, uncertainty)
Makie.preferred_axis_type(::VSUPLegend) = Makie.PolarAxis

function _getline(x, θ₀, θ₁)
    return [
        (θ₀, 0),
        [(θ, x) for θ in LinRange(θ₀, θ₁, 60)]...,
        (θ₀, 0),
    ]
end

function Makie.plot!(vl::VSUPLegend)
    # Value bins
    valuebins = 2^(vl.bins[] - 1)

    # First, we get the palette with increasing amounts of masking
    newpal = _vsup_grid(
        vl.bins[],
        vl.colormap[],
        vl.color[],
    )

    # Now we can assemble the polygons
    for i in Base.OneTo(vl.bins[])
        poly!(vl, _getline(i, vl.direction[]-0.5*vl.span[], vl.direction[]+0.5*vl.span[]), color=rand(newpal))
    end

    return vl
end

end