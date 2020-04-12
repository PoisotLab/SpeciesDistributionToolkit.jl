"""
All types in the package are part of the abstract type `SimpleSDMLayer`. A
`SimpleSDMLayer` has five core fields: `grid` is a matrix storing the cells, and
`left`, `right`, `bottom` and `top` are floating point numbers specifying the
bounding box.

It is assumed that the missing values will be represented as `nothing`, so
internally the matrix will have type `Union{T, Nothing}`.
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
    grid::Matrix{Union{Nothing,T}}
    left::AbstractFloat
    right::AbstractFloat
    bottom::AbstractFloat
    top::AbstractFloat
    function SimpleSDMPredictor(grid::Matrix{T}, l::K, r::K, b::K, t::K) where {T, K<:AbstractFloat}
        return new{T}(convert(Matrix{Union{Nothing,T}}, grid), l, r, b, t)
    end
end

"""
    SimpleSDMPredictor(grid::Matrix{T}) where {T}

If only a matrix is given to `SimpleSDMPredictor`, by default we assume that it
covers the entire range of latitudes and longitudes.
"""
function SimpleSDMPredictor(grid::Matrix{T}) where {T}
    return SimpleSDMPredictor(grid, -180.0, 180.0, -90.0, 90.0)
end


"""
A response is a `SimpleSDMLayer` that is mutable, and is the usual type to store
analysis outputs. You can transform a response into a predictor using `convert`.
"""
mutable struct SimpleSDMResponse{T} <: SimpleSDMLayer
    grid::Matrix{Union{Nothing,T}}
    left::AbstractFloat
    right::AbstractFloat
    bottom::AbstractFloat
    top::AbstractFloat
    function SimpleSDMResponse(grid::Matrix{T}, l::K, r::K, b::K, t::K) where {T, K<:AbstractFloat}
        return new{T}(convert(Matrix{Union{Nothing,T}}, grid), l, r, b, t)
    end
end

"""
    SimpleSDMResponse(grid::Matrix{T}) where {T}

If only a matrix is given to `SimpleSDMResponse`, by default we assume that it
covers the entire range of latitudes and longitudes.
"""
function SimpleSDMResponse(grid::Matrix{T}) where {T}
    return SimpleSDMResponse(grid, -180.0, 180.0, -90.0, 90.0)
end