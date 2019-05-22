import Base: size
import Base: stride
import Base: eachindex
import Base: getindex

function Base.size(p::T) where {T <: SimpleSDMLayer}
    return size(p.grid)
end

function Base.size(p::T, i...) where {T <: SimpleSDMLayer}
    return size(p.grid, i...)
end

function Base.stride(p::T; dims::Union{Nothing,Integer}=nothing) where {T <: SimpleSDMLayer}
    lon_stride = (p.right-p.left)/size(p, 2)/2.0
    lat_stride = (p.top-p.bottom)/size(p, 1)/2.0
    dims == nothing && return (lon_stride, lat_stride)
    dims == 1 && return lon_stride
    dims == 2 && return lat_stride
end

function Base.eachindex(p::T) where {T <: SimpleSDMLayer}
    return eachindex(p.grid)
end

"""
Extracts a  value from a layer by its grid position. 
"""
function Base.getindex(p::T, i::Int64) where {T <: SimpleSDMLayer}
    return p.grid[i]
end

"""
Extracts a series of positions in a layer, and returns a layer corresponding to
the result. This is essentially a way to rapidly crop a layer to a given subset
of its extent. The `i` and `j` arguments are `UnitRange`s (of `Integer`).

The layer returned by this function will have the same type as the layer
passed as its argument.
"""
function Base.getindex(p::T, i::R, j::R) where {T <: SimpleSDMLayer, R <: UnitRange}
    return T(
        p.grid[i,j],
        minimum(longitudes(p)[j])-stride(p)[1],
        maximum(longitudes(p)[j])+stride(p)[1],
        minimum(latitudes(p)[i])-stride(p)[2],
        maximum(latitudes(p)[i])+stride(p)[2]
        )
end


"""
Extracts the value of a layer at a given latitude and longitude. If values
outside the range are requested, will return `NaN`. 
"""
function Base.getindex(p::T, longitude::K, latitude::K) where {T <: SimpleSDMLayer, K <: AbstractFloat}
    longitude < p.left && return NaN
    longitude > p.right && return NaN
    latitude < p.bottom && return NaN
    latitude > p.top && return NaN
    i_lon = findmin(abs.(longitude .- longitudes(p)))[2]
    j_lat = findmin(abs.(latitude .- latitudes(p)))[2]
    return p.grid[j_lat, i_lon]
end
