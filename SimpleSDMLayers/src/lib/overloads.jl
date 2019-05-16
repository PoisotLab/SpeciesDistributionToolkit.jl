import Base: size
import Base: stride
import Base: eachindex
import Base: getindex

function Base.size(p::T) where {T <: SimpleSDMLayer}
    return size(p.grid)
end

function Base.size(p::T; i...) where {T <: SimpleSDMLayer}
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

function Base.getindex(p::T; i...) where {T <: SimpleSDMLayer}
    return p.grid[i...]
end

function Base.getindex(p::T, longitude::K, latitude::K) where {T <: SimpleSDMLayer, K <: AbstractFloat}
    longitude < p.left && return NaN
    longitude > p.right && return NaN
    latitude < p.bottom && return NaN
    latitude > p.top && return NaN
    i_lon = findmin(abs.(longitude .- longitudes(p)))[2]
    j_lat = findmin(abs.(latitude .- latitudes(p)))[2]
    return p[j_lat, i_lon]
end
