import Base: size
import Base: stride
import Base: eachindex
import Base: getindex
import Base: similar
import Base: copy

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
Given a layer and a latitude, returns NaN if the latitude is outside the
range, or the grid index containing this latitude if it is within range
"""
function match_latitude(p::T, l::K) where {T <: SimpleSDMLayer, K <: AbstractFloat}
   l > p.top && return NaN
   l < p.bottom && return NaN
   return findmin(abs.(l .- latitudes(p)))[2]
end

"""
Given a layer and a longitude, returns NaN if the longitude is outside the
range, or the grid index containing this longitude if it is within range
"""
function match_longitude(p::T, l::K) where {T <: SimpleSDMLayer, K <: AbstractFloat}
   l > p.right && return NaN
   l < p.left && return NaN
   return findmin(abs.(l .- longitudes(p)))[2]
end

"""
Extracts the value of a layer at a given latitude and longitude. If values
outside the range are requested, will return `NaN`. 
"""
function Base.getindex(p::T, longitude::K, latitude::K) where {T <: SimpleSDMLayer, K <: AbstractFloat}
   i = match_longitude(p, longitude)
   j = match_latitude(p, latitude)
   isnan(i) && return NaN
   isnan(j) && return NaN
   return p.grid[j, i]
end

""" Extracts a series of positions in a layer, and returns a layer
corresponding to the result. This is essentially a way to rapidly crop a
layer to a given subset of its extent. The `longitudes` and `latitudes`
arguments are tuples of floating point values, representing the bounding
box of the layer to extract.

The layer returned by this function will have the same type as the layer
passed as its argument.
"""
function Base.getindex(p::T, longitudes::Tuple{K,K}, latitudes::Tuple{K,K}) where {T <: SimpleSDMLayer, K <: AbstractFloat}
   imin, imax = [match_longitude(p, l) for l in longitudes]
   jmin, jmax = [match_latitude(p, l) for l in latitudes]
   any(isnan.([imin, imax, jmin, jmax])) && throw(ArgumentError("Unable to extract, coordinates outside of range"))
   return p[jmin:jmax, imin:imax]
end


"""
Extract a layer based on a second layer -- because the two layers do not
necesarily have the same origins and/or strides, this does not ensure that
they can be overlaid, but this is a good first order approximation.
"""
function Base.getindex(p1::T1, p2::T2) where {T1 <: SimpleSDMLayer, T2 <: SimpleSDMLayer}
   return p1[(p2.left, p2.right), (p2.bottom, p2.top)]
end

function Base.setindex!(p::T, v, i...) where {T <: SimpleSDMResponse}
   @assert typeof(v) == eltype(p.grid)
   p.grid[i...] = v
end

function Base.setindex!(p::T, v, lon::Float64, lat::Float64) where {T <: SimpleSDMResponse}
   i = match_longitude(p, lon)
   j = match_latitude(p, lat)
   p[j,i] = v
end

"""
Always returns a SimpleSDMResponse

Returns NaN for NaN, and eltype zero for other values
"""
function Base.similar(l::T) where {T <: SimpleSDMLayer}
   emptygrid = similar(l.grid)
   for i in eachindex(emptygrid)
      emptygrid[i] = isnan(l.grid[i]) ? NaN : zero(eltype(l.grid))
   end
   return SimpleSDMResponse(emptygrid, l.left, l.right, l.bottom, l.top)
end

"""
Returns the same type
"""
function Base.copy(l::T) where {T <: SimpleSDMLayer}
   copygrid = copy(l.grid)
   return T(copygrid, l.left, l.right, l.bottom, l.top)
end
