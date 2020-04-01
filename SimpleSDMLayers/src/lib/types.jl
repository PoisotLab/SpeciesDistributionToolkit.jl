"""
All types in the package are part of the abstract type `SimpleSDMLayer`. A
`SimpleSDMLayer` has five core fields: `grid` is a matrix storing the cells, and
`left`, `right`, `bottom` and `top` are floating point numbers specifying the
bounding box.

It is assumed that the missing values will be represented as `NaN`, so the
"natural" type for the values of `grid` are floating points, but it is possible
to use any other type `T` by having `grid` contain `Union{T,Float64}` (for
example).
"""
abstract type SimpleSDMLayer end

"""
A predictor is a `SimpleSDMLayer` that is immutable, and so does not have
methods for `setindex!`, etc. It is a safe way to store values that should not
be modified by the analysis. Note that if you are in a bind, the values of the
`grid` field are not immutable, but don't tell anyone we told you. The correct
way of handling predictors you need to modify would be to use `convert` methods.
"""
struct SimpleSDMPredictor{T} <: SimpleSDMLayer
    grid::Matrix{T}
    left::AbstractFloat
    right::AbstractFloat
    bottom::AbstractFloat
    top::AbstractFloat
end

function SimpleSDMPredictor(grid::Matrix{T}) where {T}
    return SimpleSDMPredictor(grid, -180., 180., -90., 90.)
end

"""
A response is a `SimpleSDMLayer` that is mutable, and is the usual type to store
analysis outputs. You can transform a response into a predictor using `convert`.
"""
mutable struct SimpleSDMResponse{T} <: SimpleSDMLayer
    grid::Matrix{T}
    left::AbstractFloat
    right::AbstractFloat
    bottom::AbstractFloat
    top::AbstractFloat
end

function SimpleSDMResponse(grid::Matrix{T}) where {T}
    return SimpleSDMPredictor(grid, -180., 180., -90., 90.)
end
