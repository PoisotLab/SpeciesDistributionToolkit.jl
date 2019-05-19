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
