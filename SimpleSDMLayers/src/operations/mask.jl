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


_format_polygon(xy) = Polygon([Point(c[1], c[2]) for c in xy[1]])

function _points_from_polygon(poly)
    pl = Point[]
    for i in 1:length(poly.exterior)
        push!(pl, poly.exterior[i][1])
    end
    push!(pl, pl[1])
    return pl
end

function _mask_from_polygon(polygon::Polygon, layer::T) where {T <: SimpleSDMLayer}
    msk = similar(layer, Bool)
    pts = _points_from_polygon(polygon)
    keep = filter(p -> inpolygon(Array(p), pts)!=0, keys(layer))
    if length(keep) > 0
        msk[keep] = fill(true, length(keep))
    end
    return msk
end

function mask(multipolygon::P, layer::T) where {T <: SimpleSDMLayer, P <: Vector{<:GeometryBasics.Polygon}}
    msks = [_mask_from_polygon(polygon, layer) for polygon in multipolygon]
    return mask(maximum(msks), layer)
end

function mask(polygon::Polygon, layer::T) where {T <: SimpleSDMLayer}
    msk = _mask_from_polygon(polygon, layer)
    return mask(msk, layer)
end

function mask(circle::Circle, layer::T) where {T <: SimpleSDMLayer}
    msk = similar(layer, Bool)
    keep = filter(k -> k in circle, keys(layer))
    if length(keep) > 0
        msk[keep] = fill(true, length(keep))
    end
    return mask(msk, layer)
end