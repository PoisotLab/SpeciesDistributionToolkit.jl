import Base: size
import Base: stride
import Base: eachindex
import Base: getindex
import Base: setindex!
import Base: similar
import Base: copy
import Base: eltype
import Base: convert

"""
    Base.convert(::Type{SimpleSDMResponse}, layer::T) where {T <: SimpleSDMPredictor}

Returns a response with the same grid and bounding box as the predictor.
"""
function Base.convert(::Type{SimpleSDMResponse}, layer::T) where {T <: SimpleSDMPredictor}
   return copy(SimpleSDMResponse(layer.grid, layer.left, layer.right, layer.bottom, layer.top))
end

"""
    Base.convert(::Type{SimpleSDMPredictor}, layer::T) where {T <: SimpleSDMResponse}

Returns a predictor with the same grid and bounding box as the response.
"""
function Base.convert(::Type{SimpleSDMPredictor}, layer::T) where {T <: SimpleSDMResponse}
   return copy(SimpleSDMPredictor(layer.grid, layer.left, layer.right, layer.bottom, layer.top))
end

"""
    Base.convert(::Type{Matrix}, layer::T) where {T <: SimpleSDMLayer}

Returns the grid as an array.
"""
function Base.convert(::Type{Matrix}, layer::T) where {T <: SimpleSDMLayer}
   return copy(layer.grid)
end

"""
    Base.eltype(layer::T) where {T <: SimpleSDMLayer}

Returns the type of the values stored in the grid.
"""
function Base.eltype(layer::T) where {T <: SimpleSDMLayer}
   return eltype(layer.grid)
end

"""
    Base.size(layer::T) where {T <: SimpleSDMLayer}

Returns the size of the grid.
"""
function Base.size(layer::T) where {T <: SimpleSDMLayer}
   return size(layer.grid)
end

"""
    Base.size(layer::T, i...) where {T <: SimpleSDMLayer}

Returns the size of the grid alongside a dimension.
"""

function Base.size(layer::T, i...) where {T <: SimpleSDMLayer}
   return size(layer.grid, i...)
end

"""
    Base.stride(layer::T; dims::Union{Nothing,Integer}=nothing) where {T <: SimpleSDMLayer}

Returns the stride, *i.e.* the length, of cell dimensions, possibly alongside a
side of the grid.
"""
function Base.stride(layer::T; dims::Union{Nothing,Integer}=nothing) where {T <: SimpleSDMLayer}
   lon_stride = (layer.right-layer.left)/size(layer, 2)/2.0
   lat_stride = (layer.top-layer.bottom)/size(layer, 1)/2.0
   dims == nothing && return (lon_stride, lat_stride)
   dims == 1 && return lon_stride
   dims == 2 && return lat_stride
end

"""
    Base.eachindex(layer::T) where {T <: SimpleSDMLayer}

Returns the index of the grid.
"""
function Base.eachindex(layer::T) where {T <: SimpleSDMLayer}
   return eachindex(layer.grid)
end

"""
Extracts a  value from a layer by its grid position.
"""
function Base.getindex(layer::T, i::Int64) where {T <: SimpleSDMLayer}
   return layer.grid[i]
end

"""
    Base.getindex(layer::T, i::R, j::R) where {T <: SimpleSDMLayer, R <: UnitRange}

Extracts a series of positions in a layer, and returns a layer corresponding to
the result. This is essentially a way to rapidly crop a layer to a given subset
of its extent. The `i` and `j` arguments are `UnitRange`s (of `Integer`).

The layer returned by this function will have the same type as the layer passed
as its argument, but this can be changed using `convert`. Note that this function
performs additional checks to ensure that the range is not empty, and to also
ensure that it does not overflows from the size of the layer.
"""
function Base.getindex(layer::T, i::R, j::R) where {T <: SimpleSDMLayer, R <: UnitRange}
   i_min = isempty(i) ? max(i.start-1, 1) : i.start
   i_max = isempty(i) ? max(i.stop+2, size(layer, 1)) : i.stop
   j_min = isempty(j) ? max(j.start-1, 1) : j.start
   j_max = isempty(j) ? max(j.stop+2, size(layer, 2)) : j.stop
   i_fix = i_min:i_max
   j_fix = j_min:j_max
   return T(
            layer.grid[i_fix,j_fix],
            minimum(longitudes(layer)[j_fix])-stride(layer)[1],
            maximum(longitudes(layer)[j_fix])+stride(layer)[1],
            minimum(latitudes(layer)[i_fix])-stride(layer)[2],
            maximum(latitudes(layer)[i_fix])+stride(layer)[2]
           )
end

"""
Given a layer and a latitude, returns NaN if the latitude is outside the
range, or the grid index containing this latitude if it is within range
"""
function _match_latitude(layer::T, lat::K) where {T <: SimpleSDMLayer, K <: AbstractFloat}
   lat > layer.top && return NaN
   lat < layer.bottom && return NaN
   return findmin(abs.(lat .- latitudes(layer)))[2]
end

"""
Given a layer and a longitude, returns NaN if the longitude is outside the
range, or the grid index containing this longitude if it is within range
"""
function _match_longitude(layer::T, lon::K) where {T <: SimpleSDMLayer, K <: AbstractFloat}
   lon > layer.right && return NaN
   lon < layer.left && return NaN
   return findmin(abs.(lon .- longitudes(layer)))[2]
end

"""
    Base.getindex(layer::T, longitude::K, latitude::K) where {T <: SimpleSDMLayer, K <: AbstractFloat}

Extracts the value of a layer at a given latitude and longitude. If values
outside the range are requested, will return `NaN`.
"""
function Base.getindex(layer::T, longitude::K, latitude::K) where {T <: SimpleSDMLayer, K <: AbstractFloat}
   i = _match_longitude(layer, longitude)
   j = _match_latitude(layer, latitude)
   isnan(i) && return NaN
   isnan(j) && return NaN
   return layer.grid[j, i]
end

"""
    Base.getindex(layer::T; left=nothing, right=nothing, top=nothing, bottom=nothing) where {T <: SimpleSDMLayer, K <: Union{Nothing,AbstractFloat}}

Returns a subset of the argument layer, where the new limits are given by
`left`, `right`, `top`, and `bottom`. Up to three of these can be omitted, and
if so these limits will not be affected.
"""
function Base.getindex(layer::T; left=nothing, right=nothing, top=nothing, bottom=nothing) where {T <: SimpleSDMLayer}
   for limit in [left, right, top, bottom]
      if !isnothing(limit)
         @assert typeof(limit) <: AbstractFloat
      end
   end
   imax = _match_longitude(layer, isnothing(right) ? layer.right : right)
   imin = _match_longitude(layer, isnothing(left) ? layer.left : left)
   jmax = _match_latitude(layer, isnothing(top) ? layer.top : top)
   jmin = _match_latitude(layer, isnothing(bottom) ? layer.bottom : bottom)
   any(isnan.([imin, imax, jmin, jmax])) && throw(ArgumentError("Unable to extract, coordinates outside of range"))
   return layer[jmin:jmax, imin:imax]
end

"""
    Base.getindex(layer::T, n::NT) where {T <: SimpleSDMLayer, NT <: NamedTuple}

Returns a subset of the argument layer, where the new limits are given in
a NamedTuple by `left`, `right`, `top`, and `bottom`, in any order. Up to 
three of these can be omitted, and if so these limits will not be affected.
"""
function Base.getindex(layer::T, n::NT) where {T <: SimpleSDMLayer, NT <: NamedTuple}
    l = isdefined(n, :left) ? n.left : nothing
    r = isdefined(n, :right) ? n.right : nothing
    t = isdefined(n, :top) ? n.top : nothing
    b = isdefined(n, :bottom) ? n.bottom : nothing
    Base.getindex(layer; left=l, right=r, top=t, bottom=b)
end

"""
    Base.getindex(layer1::T1, layer2::T2) where {T1 <: SimpleSDMLayer, T2 <: SimpleSDMLayer}

Extract a layer based on a second layer. Note that the two layers must be
*compatible*, which is to say they must have the same bounding box and grid
size.
"""
function Base.getindex(layer1::T1, layer2::T2) where {T1 <: SimpleSDMLayer, T2 <: SimpleSDMLayer}
   SimpleSDMLayers._layers_are_compatible(layer1, layer2)
   return layer1[left=layer2.left, right=layer2.right, bottom=layer2.bottom, top=layer2.top]
end

"""
     Base.setindex!(layer::SimpleSDMResponse{T}, v::T, i...) where {T}

Changes the value of a cell, or a range of cells, as indicated by their grid
positions.
"""
function Base.setindex!(layer::SimpleSDMResponse{T}, v::T, i...) where {T}
   typeof(v) <: eltype(layer.grid) || throw(ArgumentError("Impossible to set a value to a non-matching type"))
   layer.grid[i...] = v
end

"""
    Base.setindex!(layer::T, v, lon::Float64, lat::Float64) where {T <: SimpleSDMResponse}

Changes the values of the cell including the point at the requested latitude and
longitude.
"""
function Base.setindex!(layer::SimpleSDMResponse{T}, v::T, lon::Float64, lat::Float64) where {T}
   i = _match_longitude(layer, lon)
   j = _match_latitude(layer, lat)
   layer[j,i] = v
end

"""
    Base.similar(l::T) where {T <: SimpleSDMLayer}

Returns a `SimpleSDMResponse` of the same dimensions as the original layer, with
`NaN` in the same positions. The rest of the values are replaced by the output
of `zero(eltype(layer.grid))`, which implies that there must be a way to get a zero
for the type. If not, the same result can always be achieved through the use of
`copy`, manual update, and `convert`.
"""
function Base.similar(layer::T) where {T <: SimpleSDMLayer}
   emptygrid = similar(layer.grid)
   for i in eachindex(emptygrid)
      emptygrid[i] = isnan(layer.grid[i]) ? NaN : zero(eltype(layer.grid))
   end
   return SimpleSDMResponse(emptygrid, layer.left, layer.right, layer.bottom, layer.top)
end

"""
    Base.copy(l::T) where {T <: SimpleSDMLayer}

Returns a new copy of the layer, which has the same type.
"""
function Base.copy(layer::T) where {T <: SimpleSDMLayer}
   copygrid = copy(layer.grid)
   return T(copygrid, copy(layer.left), copy(layer.right), copy(layer.bottom), copy(layer.top))
end
