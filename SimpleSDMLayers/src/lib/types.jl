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
    function SimpleSDMPredictor(grid::Matrix{Union{Nothing,T}}, l::K, r::K, b::K, t::K) where {T, K<:AbstractFloat}
        return new{T}(grid, l, r, b, t)
    end
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
    function SimpleSDMResponse(grid::Matrix{Union{Nothing,T}}, l::K, r::K, b::K, t::K) where {T, K<:AbstractFloat}
        return new{T}(grid, l, r, b, t)
    end
end

# Begin code generation for the constructors

simplesdm_types = (:SimpleSDMResponse, :SimpleSDMPredictor)

for simplesdm_type in simplesdm_types
    eval(quote
        function $simplesdm_type(grid::Matrix{Union{Nothing,T}}) where {T}
            return $simplesdm_type(grid, -180.0, 180.0, -90.0, 90.0)
        end

        function $simplesdm_type(grid::Matrix{T}) where {T}
            return $simplesdm_type(convert(Matrix{Union{Nothing,T}}, grid), -180.0, 180.0, -90.0, 90.0)
        end

        function $simplesdm_type(grid::Matrix{T}, l::K, r::K, b::K, t::K) where {T, K<:AbstractFloat}
            return $simplesdm_type(convert(Matrix{Union{Nothing,T}}, grid), l, r, b, t)
        end

        function $simplesdm_type(grid::Matrix{T}, L::K) where {T, K<:SimpleSDMLayer}
            return $simplesdm_type(convert(Matrix{Union{Nothing,T}}, grid), L.left, L.right, L.bottom, L.top)
        end
    end)
end
