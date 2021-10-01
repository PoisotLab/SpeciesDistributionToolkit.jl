import Base: stride
import Base: eachindex
import Base: replace
import Base: replace!
import Base: similar
import Base: copy
import Base: eltype
import Base: convert
import Base: collect
import Base.Broadcast: broadcast
import Base: hcat
import Base: vcat
import Base: show
import Base: ==
import Base: isequal
import Base: hash

"""
    Base.show(io::IO, ::MIME"text/plain", layer::T) where {T <: SimpleSDMLayer}
    Base.show(io::IO, layer::T) where {T <: SimpleSDMLayer}

Shows a textual representation of the layer.
"""
function Base.show(io::IO, ::MIME"text/plain", layer::T) where {T <: SimpleSDMLayer}
    itype = eltype(layer)
    otype = T <: SimpleSDMPredictor ? "predictor" : "response"
    print(io, """SDM $(otype) → $(size(layer,1))×$(size(layer,2)) grid with $(length(layer)) $(itype)-valued cells
    \x20\x20Latitudes\t$(Tuple(latitudes(layer)[[1, end]]))
    \x20\x20Longitudes\t$(Tuple(longitudes(layer)[[1, end]]))""")
end

function Base.show(io::IO, layer::T) where {T <: SimpleSDMLayer}
    itype = eltype(layer)
    otype = T <: SimpleSDMPredictor ? "predictor" : "response"
    print(io, "SDM $(otype) → $(size(layer,1))×$(size(layer,2)) grid with $(length(layer)) $(itype)-valued cells")
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
Given a layer and a latitude, returns `nothing` if the latitude is outside the
range, or the grid index containing this latitude if it is within range
"""
function _match_latitude(layer::T, lat::K; side=:none) where {T <: SimpleSDMLayer, K <: AbstractFloat}
    side in [:none, :bottom, :top] || throw(ArgumentError("side must be one of :none (default), :bottom, :top"))

    lat > layer.top && return nothing
    lat < layer.bottom && return nothing

    ldiff = abs.(lat .- latitudes(layer))
    lapprox = isapprox.(ldiff, stride(layer, 2))
    if side == :none || !any(lapprox)
        l = last(findmin(ldiff))
    elseif side == :bottom
        l = findlast(lapprox)
    elseif side == :top
        l = findfirst(lapprox)
    end
    
    return l
end


"""
Given a layer and a longitude, returns `nothing` if the longitude is outside the
range, or the grid index containing this longitude if it is within range
"""
function _match_longitude(layer::T, lon::K; side::Symbol=:none) where {T <: SimpleSDMLayer, K <: AbstractFloat}
    side in [:none, :left, :right] || throw(ArgumentError("side must be one of :none (default), :left, :right"))
    
    lon > layer.right && return nothing
    lon < layer.left && return nothing
    
    ldiff = abs.(lon .- longitudes(layer))
    lapprox = isapprox.(ldiff, stride(layer, 1))
    if side == :none || !any(lapprox)
        l = last(findmin(ldiff))
    elseif side == :left
        l = findlast(lapprox)
    elseif side == :right
        l = findfirst(lapprox)
    end

    return l
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

Adds the second layer *under* the first one (according to coordinates), 
assuming the strides and left/right coordinates match. This will automatically
re-order the layers if the second is above the first.
"""
function Base.vcat(l1::T, l2::T) where {T <: SimpleSDMLayer}
    (l1.left == l2.left) || throw(ArgumentError("The two layers passed to vcat must have the same left coordinate"))
    (l1.right == l2.right) || throw(ArgumentError("The two layers passed to vcat must have the same right coordinate"))
    all(stride(l1) .≈ stride(l2)) || throw(ArgumentError("The two layers passed to vcat must have the same stride"))
    (l1.top == l2.bottom) && return vcat(l2, l1)
    (l2.top == l1.bottom) || throw(ArgumentError("The two layers passed to vcat must have contiguous bottom and top coordinates"))
    new_grid = vcat(l2.grid, l1.grid)
    RT = T <: SimpleSDMPredictor ? SimpleSDMPredictor : SimpleSDMResponse
    return RT(new_grid, l1.left, l1.right, l2.bottom, l1.top)
end

"""
    Base.hcat(l1::T, l2::T) where {T <: SimpleSDMLayers}

Adds the second layer *to the right of* the first one (according to coordinates),
assuming the strides and left/right coordinates match. This will automatically 
re-order the layers if the second is to the left the first.
"""
function Base.hcat(l1::T, l2::T) where {T <: SimpleSDMLayer}
    (l1.top == l2.top) || throw(ArgumentError("The two layers passed to hcat must have the same top coordinate"))
    (l1.bottom == l2.bottom) || throw(ArgumentError("The two layers passed to hcat must have the same bottom coordinate"))
    all(stride(l1) .≈ stride(l2)) || throw(ArgumentError("The two layers passed to hcat must have the same stride"))
    (l2.right == l1.left) && return hcat(l2, l1)
    (l1.right == l2.left) || throw(ArgumentError("The two layers passed to hcat must have contiguous left and right coordinates"))
    new_grid = hcat(l1.grid, l2.grid)
    RT = T <: SimpleSDMPredictor ? SimpleSDMPredictor : SimpleSDMResponse
    return RT(new_grid, l1.left, l2.right, l1.bottom, l1.top)
end

"""
    Base.replace!(layer::T, old_new::Pair...) where {T <: SimpleSDMLayer}

Replaces the elements of `layer` according to a series of pairs. In place. Only
possible for `SimpleSDMResponse` elements (which are mutable) and will throw an
error if called on a `SimpleSDMPredictor` element (which is not mutable).
"""
function Base.replace!(layer::T, old_new::Pair...) where {T <: SimpleSDMLayer}
    layer isa SimpleSDMResponse || throw(ArgumentError("`SimpleSDMPredictor` elements are immutable. Convert to a `SimpleSDMResponse` first or call `replace!` directly on the grid element."))
    replace!(layer.grid, old_new...)
    return layer
end

"""
    Base.replace(layer::T, old_new::Pair...) where {T <: SimpleSDMResponse}

Replaces the elements of `layer` according to a series of pairs. Returns a copy.
"""
function Base.replace(layer::T, old_new::Pair...) where {T <: SimpleSDMResponse}
    destination = copy(layer)
    replace!(destination, old_new...)
    return destination
end

"""
    Base.replace(layer::T, old_new::Pair...) where {T <: SimpleSDMPredictor}

Replaces the elements of `layer` according to a series of pairs. Copies the
layer as a response before.
"""
function Base.replace(layer::T, old_new::Pair...) where {T <: SimpleSDMPredictor}
    destination = SimpleSDMResponse(copy(layer.grid), layer)
    replace!(destination, old_new...)
    return destination
end

"""
    quantile(layer::T, p) where {T <: SimpleSDMLayer}

Returns the quantiles of `layer` at `p`, using `Statistics.quantile`.
"""
function Statistics.quantile(layer::T, p) where {T <: SimpleSDMLayer}
    return quantile(collect(layer), p)
end

"""
    ==(layer1::SimpleSDMLayer, layer2::SimpleSDMLayer)

Tests whether two `SimpleSDMLayer` elements are equal. The layers are equal if 
all their fields (`grid`, `left`, `right`, `bottom`, `top`) are equal, as 
verified with `==` (e.g., `layer1.grid == layer2.grid`).
"""
function Base.:(==)(layer1::SimpleSDMLayer, layer2::SimpleSDMLayer)
    return all(
        [
            layer1.grid == layer2.grid,
            layer1.left == layer2.left,
            layer1.right == layer2.right,
            layer1.bottom == layer2.bottom,
            layer1.top == layer2.top,
        ]
    )
end

function Base.hash(layer::SimpleSDMLayer, h::UInt)
    return hash((layer.grid, layer.left, layer.right, layer.bottom, layer.top), h)
end

"""
    isequal(layer1::SimpleSDMLayer, layer2::SimpleSDMLayer)

Tests whether two `SimpleSDMLayer` elements are equal. The layers are equal if 
all their fields (`grid`, `left`, `right`, `bottom`, `top`) are equal, as 
verified with `isequal` (e.g., `isequal(layer1.grid, layer2.grid)`).
"""
function Base.isequal(layer1::SimpleSDMLayer, layer2::SimpleSDMLayer)
    return all(
        [
            isequal(layer1.grid, layer2.grid),
            isequal(layer1.left, layer2.left),
            isequal(layer1.right, layer2.right),
            isequal(layer1.bottom, layer2.bottom),
            isequal(layer1.top, layer2.top),
        ]
    )
end
