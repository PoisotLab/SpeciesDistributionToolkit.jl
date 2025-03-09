
"""
    backgroundpoints(layer::T, n::Int; replace::Bool=false, kwargs...) where {T <: SimpleSDMLayer}

Generates background points based on a layer that gives the weight of each cell
in the final sample. Note that the default value is to draw without replacement,
but this can be changed using `replace=true`. The additional keywors arguments
are passed to `StatsBase.sample`, which is used internally.
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

"""
    backgroundpoints(layer::SDMLayer{Bool}, n::Int; replace::Bool=false, kwargs...)

Generates background points based on a layer that gives the location of possible
points. Note that the default value is to draw without replacement, but
this can be changed using `replace=true`. The additional keywors arguments are
passed to `StatsBase.sample`, which is used internally.
"""
function backgroundpoints(layer::SDMLayer{Bool}, n::Int; kwargs...)
    background = zeros(layer, Bool)
    selected_points = StatsBase.sample(keys(layer), n; kwargs...)
    for sp in selected_points
        background[sp] = true
    end
    return background
end