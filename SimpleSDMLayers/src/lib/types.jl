"""
TODO
"""
abstract type SimpleSDMLayer end

"""
TODO
"""
struct SimpleSDMPredictor{T,K <: AbstractFloat} <: SimpleSDMLayer
    grid::Matrix{T}
    left::K
    right::K
    bottom::K
    top::K
end

"""
TODO
"""
mutable struct SimpleSDMResponse{T,K <: AbstractFloat} <: SimpleSDMLayer
    grid::Matrix{T}
    left::K
    right::K
    bottom::K
    top::K
end
