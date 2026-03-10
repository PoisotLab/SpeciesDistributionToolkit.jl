module VSUPExtension

using SpeciesDistributionToolkit
import SpeciesDistributionToolkit: vsup, vsup!
using Makie

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

end