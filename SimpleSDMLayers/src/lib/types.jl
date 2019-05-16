abstract type SimpleSDMLayer end

struct SimpleSDMPredictor{T,K <: AbstractFloat} <: SimpleSDMLayer
    grid::Matrix{T}
    left::K
    right::K
    bottom::K
    top::K
end

mutable struct SimpleSDMResponse{T,K <: AbstractFloat} <: SimpleSDMLayer
    grid::Matrix{T}
    left::K
    right::K
    bottom::K
    top::K
end
