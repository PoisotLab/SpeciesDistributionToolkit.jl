import Base: size
import Base: stride
import Base: eachindex
import Base: getindex
import Base: setindex!
import Base: similar
import Base: copy
import Base: eltype
import Base: convert
import Base: collect
import Base.Broadcast: broadcast
import Base: hcat
import Base: vcat
import Base: show

"""
    Base.show(io::IO, layer::T) where {T <: SimpleSDMLayer}

Shows a textual representation of the layer.
"""
function Base.show(io::IO, layer::T) where {T <: SimpleSDMLayer}
    itype = eltype(layer)
    otype = T <: SimpleSDMPredictor ? "predictor" : "response"
    print(io, """SDM $(otype) with $(itype) values
    $(size(layer,1)) × $(size(layer,2))
    lat.: $(extrema(latitudes(layer)))
    lon.: $(extrema(longitudes(layer)))""")
end

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
    Base.convert(::Type{T}, layer::TL) where {T <: Number, TL <: SimpleSDMLayer}

Returns a copy of the layer with the same type (response or predictor), but the
element type has been changed to `T` (which must be a number). This function is
*extremely useful* (required, in fact) for plotting, as the `nothing` values are
changed to `NaN` in the heatmaps.
"""
function Base.convert(::Type{T}, layer::TL) where {T <: Number, TL <: SimpleSDMLayer}
    new = similar(layer, T)
    new.grid[.!isnothing.(layer.grid)] .= convert.(T, layer.grid[.!isnothing.(layer.grid)])
    return new
end

"""
    Base.convert(::Type{Matrix}, layer::T) where {T <: SimpleSDMLayer}

Returns the grid as an array.
"""
function Base.convert(::Type{Matrix}, layer::T) where {T <: SimpleSDMLayer}
   return copy(layer.grid)
end

"""
    Base.eltype(layer::SimpleSDMLayer{T}) where {T}

Returns the type of the values stored in the grid, where the `Nothing` type is
omitted.
"""
Base.eltype(::SimpleSDMResponse{T}) where {T} = T
Base.eltype(::SimpleSDMPredictor{T}) where {T} = T


"""
    Base.size(layer::T) where {T <: SimpleSDMLayer}

Returns the size of the grid.
"""
Base.size(layer::T) where {T <: SimpleSDMLayer} = size(layer.grid)


"""
    Base.size(layer::T, i...) where {T <: SimpleSDMLayer}

Returns the size of the grid alongside a dimension.
"""
Base.size(layer::T, i...) where {T <: SimpleSDMLayer} = size(layer.grid, i...)


"""
    Base.stride(layer::T; dims::Union{Nothing,Integer}=nothing) where {T <: SimpleSDMLayer}

Returns the stride, *i.e.* half the length, of cell dimensions, possibly
alongside a side of the grid. The first position is the length of the
*longitude* cells, the second the *latitude*.
"""
function Base.stride(layer::T; dims::Union{Nothing,Integer}=nothing) where {T <: SimpleSDMLayer}
   lon_stride = (layer.right-layer.left)/2.0size(layer, 2)
   lat_stride = (layer.top-layer.bottom)/2.0size(layer, 1)
   isnothing(dims) && return (lon_stride, lat_stride)
   dims == 1 && return lon_stride
   dims == 2 && return lat_stride
end
Base.stride(layer::T, i::Int) where {T<:SimpleSDMLayer} = stride(layer; dims=i)

"""
    Base.eachindex(layer::T) where {T <: SimpleSDMLayer}

Returns the index of the grid.
"""
Base.eachindex(layer::T) where {T <: SimpleSDMLayer} = eachindex(layer.grid)


"""
Extracts a  value from a layer by its grid position.
"""
Base.getindex(layer::T, i::Int64) where {T <: SimpleSDMLayer} = layer.grid[i]


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
   RT = T <: SimpleSDMResponse ? SimpleSDMResponse : SimpleSDMPredictor
   return RT(
            layer.grid[i_fix,j_fix],
            minimum(longitudes(layer)[j_fix])-stride(layer,1),
            maximum(longitudes(layer)[j_fix])+stride(layer,1),
            minimum(latitudes(layer)[i_fix])-stride(layer,2),
            maximum(latitudes(layer)[i_fix])+stride(layer,2)
           )
end

"""
Given a layer and a latitude, returns `nothing` if the latitude is outside the
range, or the grid index containing this latitude if it is within range
"""
function _match_latitude(layer::T, lat::K) where {T <: SimpleSDMLayer, K <: AbstractFloat}
   lat > layer.top && return nothing
   lat < layer.bottom && return nothing
   return last(findmin(abs.(lat .- latitudes(layer))))
end


"""
Given a layer and a longitude, returns `nothing` if the longitude is outside the
range, or the grid index containing this longitude if it is within range
"""
function _match_longitude(layer::T, lon::K) where {T <: SimpleSDMLayer, K <: AbstractFloat}
   lon > layer.right && return nothing
   lon < layer.left && return nothing
   return last(findmin(abs.(lon .- longitudes(layer))))
end

"""
    Base.getindex(layer::T, longitude::K, latitude::K) where {T <: SimpleSDMLayer, K <: AbstractFloat}

Extracts the value of a layer at a given latitude and longitude. If values
outside the range are requested, will return `nothing`.
"""
function Base.getindex(layer::T, longitude::K, latitude::K) where {T <: SimpleSDMLayer, K <: AbstractFloat}
   i = _match_longitude(layer, longitude)
   j = _match_latitude(layer, latitude)
   isnothing(i) && return nothing
   isnothing(j) && return nothing
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
   any(isnothing.([imin, imax, jmin, jmax])) && throw(ArgumentError("Unable to extract, coordinates outside of range"))
   # Note that this is LATITUDE first
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
    Base.similar(layer::T, ::Type{TC}) where {TC <: Any, T <: SimpleSDMLayer}

Returns a `SimpleSDMResponse` of the same dimensions as the original layer, with
`nothing` in the same positions. The rest of the values are replaced by the
output of `zero(TC)`, which implies that there must be a way to get a zero for
the type. If not, the same result can always be achieved through the use of
`copy`, manual update, and `convert`.
"""
function Base.similar(layer::T, ::Type{TC}) where {TC <: Any, T <: SimpleSDMLayer}
   emptygrid = convert(Matrix{Union{Nothing,TC}}, zeros(TC, size(layer)))
   emptygrid[findall(isnothing, layer.grid)] .= nothing
   return SimpleSDMResponse(emptygrid, layer.left, layer.right, layer.bottom, layer.top)
end


"""
    Base.similar(layer::T) where {T <: SimpleSDMLayer}

Returns a `SimpleSDMResponse` of the same dimensions as the original layer, with
`nothing` in the same positions. The rest of the values are replaced by the
output of `zero(element_type)`, which implies that there must be a way to get a
zero for the type. If not, the same result can always be achieved through the
use of `copy`, manual update, and `convert`.
"""
function Base.similar(layer::T) where {T <: SimpleSDMLayer}
   return similar(layer, eltype(layer))
end

"""
    Base.copy(l::T) where {T <: SimpleSDMLayer}

Returns a new copy of the layer, which has the same type.
"""
function Base.copy(layer::T) where {T <: SimpleSDMLayer}
   copygrid = copy(layer.grid)
   RT = T <: SimpleSDMResponse ? SimpleSDMResponse : SimpleSDMPredictor
   return RT(copygrid, copy(layer.left), copy(layer.right), copy(layer.bottom), copy(layer.top))
end

"""
   Broadcast.broadcast(f, L::LT) where {LT <: SimpleSDMLayer}

TODO
"""
function Base.Broadcast.broadcast(f, L::LT) where {LT <: SimpleSDMLayer}
    newgrid = Array{Any}(nothing, size(L))
    N = SimpleSDMResponse(newgrid, L)
    v = filter(!isnothing, L.grid)
    fv = f.(v)
    N.grid[findall(!isnothing, L.grid)] .= fv

    internal_types = unique(typeof.(N.grid))

    RT = LT <: SimpleSDMResponse ? SimpleSDMResponse : SimpleSDMPredictor
    return RT(convert(Matrix{Union{internal_types...}}, N.grid), N)
end

"""
    Base.collect(l::T) where {T <: SimpleSDMLayer}

Returns the non-`nothing` values of a layer.
"""
function Base.collect(l::T) where {T <: SimpleSDMLayer}
    v = filter(!isnothing, l.grid)
    return convert(Vector{typeof(v[1])}, v)    
end

"""
    Base.vcat(l1::T, l2::T) where {T <: SimpleSDMLayers}

Adds the second layer *under* the first one, assuming the strides and left/right
coordinates match. This will automatically re-order the layers if the second is
above the first.
"""
function Base.vcat(l1::T, l2::T) where {T <: SimpleSDMLayer}
    (l1.left == l2.left) || throw(ArgumentError("The two layers passed to vcat must have the same left coordinate"))
    (l1.right == l2.right) || throw(ArgumentError("The two layers passed to vcat must have the same right coordinate"))
    all(stride(l1) .≈ stride(l2)) || throw(ArgumentError("The two layers passed to vcat must have the same stride"))
    (l2.top == l1.bottom) && return vcat(l2, l1)
    new_grid = vcat(l1.grid, l2.grid)
    RT = T <: SimpleSDMPredictor ? SimpleSDMPredictor : SimpleSDMResponse
    return RT(new_grid, l1.left, l1.right, l1.top, l2.bottom)
end

"""
    Base.hcat(l1::T, l2::T) where {T <: SimpleSDMLayers}

Adds the second layer *to the right of* the first one, assuming the strides and
left/right coordinates match. This will automatically re-order the layers if the
second is to the left the first.
"""
function Base.hcat(l1::T, l2::T) where {T <: SimpleSDMLayer}
    (l1.top == l2.top) || throw(ArgumentError("The two layers passed to hcat must have the same top coordinate"))
    (l1.bottom == l2.bottom) || throw(ArgumentError("The two layers passed to hcat must have the same bottom coordinate"))
    all(stride(l1) .≈ stride(l2)) || throw(ArgumentError("The two layers passed to hcat must have the same stride"))
    (l2.right == l1.left) && return hcat(l2, l1)
    new_grid = hcat(l1.grid, l2.grid)
    RT = T <: SimpleSDMPredictor ? SimpleSDMPredictor : SimpleSDMResponse
    return RT(new_grid, l1.left, l2.right, l1.top, l1.bottom)
end

"""
    quantile(layer::T, p) where {T <: SimpleSDMLayer}

Returns the quantiles of `layer` at `p`, using `Statistics.quantile`.
"""
function Statistics.quantile(layer::T, p) where {T <: SimpleSDMLayer}
    return quantile(collect(layer), p)
end