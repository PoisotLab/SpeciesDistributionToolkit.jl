
"""
    backgroundpoints(layer::T, n::Int; kwargs...) where {T <: SimpleSDMLayer}

Generates background points based on a layer that gives the weight of each cell
in the final sample. The additional keywords arguments are passed to
`StatsBase.sample`, which is used internally. This includes the `replace`
keyword to determine whether sampling should use replacement.
"""
function backgroundpoints(layer::T, n::Int; kwargs...) where {T <: SDMLayer}
    background = zeros(layer, Bool)
    selected_points =
        StatsBase.sample(keys(layer), StatsBase.Weights(values(layer)), n; kwargs...)
    for sp in selected_points
        background[sp] = true
    end
    return background
end

@testitem "We can sample from Bool layers" begin
    x = rand(Bool, 10, 10)
    L = PseudoAbsences.SimpleSDMLayers.SDMLayer(x)
    B = backgroundpoints(L, 5)
    PseudoAbsences.SimpleSDMLayers.nodata!(B, false)
    for k in keys(B)
        @test L[k]
    end
end