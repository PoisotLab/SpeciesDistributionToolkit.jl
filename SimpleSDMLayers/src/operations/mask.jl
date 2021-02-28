_inner_type(::SimpleSDMResponse{T}) where {T <: Any} = T
_inner_type(::SimpleSDMPredictor{T}) where {T <: Any} = T

"""
    mask!(l1::T1, l2::T2) where {T1 <: SimpleSDMLayer, T2 <: SimpleSDMLayer}

Changes the second layer so that the positions for which the first layer is zero
(of the appropriate type) or `nothing` are set to `nothing`. This is mostly
useful in cases where you have a `Bool` layer.
"""
function mask!(l1::T1, l2::T2) where {T1 <: SimpleSDMLayer, T2 <: SimpleSDMLayer}
    _itype = _inner_type(l1)
    dropfunc = (x) -> isnothing(x) || (x == zero(_itype))
    todrop = findall(dropfunc, l1.grid)
    l2.grid[todrop] .= nothing
end

"""
    mask(l1::T1, l2::T2) where {T1 <: SimpleSDMLayer, T2 <: SimpleSDMLayer}

Returns a copy of the second layer in which the positions for which the first
layer is zero (of the appropriate type) or `nothing` are set to `nothing`. This
is mostly useful in cases where you have a `Bool` layer.
"""
function mask(l1::T1, l2::T2) where {T1 <: SimpleSDMLayer, T2 <: SimpleSDMLayer}
    l3 = copy(l2)
    mask!(l1, l3)
    return l3
end
