"""
    latitudes(p::T) where {T <: SimpleSDMLayer}

Returns an iterator with the latitudes of the SDM layer passed as its argument.
"""
function latitudes(p::T) where {T <: SimpleSDMLayer}
    grid_size = stride(p; dims=2)
    centers = range(p.bottom+grid_size; stop=p.top-grid_size, length=size(p, 1))
    return centers
end

"""
    longitudes(p::T) where {T <: SimpleSDMLayer}

Returns an iterator with the longitudes of the SDM layer passed as its argument.
"""
function longitudes(p::T) where {T <: SimpleSDMLayer}
    grid_size = stride(p; dims=1)
    centers = range(p.left+grid_size; stop=p.right-grid_size, length=size(p, 2))
    return centers
end

function are_compatible(l1::FT, l2::ST) where {FT <: SimpleSDMLayer, ST <: SimpleSDMLayer}
    @assert size(l1) == size(l2)
    @assert l1.top == l2.top
    @assert l1.left == l2.left
    @assert l1.bottom == l2.bottom
    @assert l1.right == l2.right
end
