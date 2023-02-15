"""
    clip(layer::T, p1::Point, p2::Point) where {T <: SimpleSDMLayer}

Return a raster by defining a bounding box through two points. The order of the
points (in terms of bottom/top/left/right) is not really important, as the
correct coordinates will be extracted.
"""
function clip(layer::T, p1::Point, p2::Point) where {T <: SimpleSDMLayer}
    latextr = extrema([p1[2], p2[2]])
    lonextr = extrema([p1[1], p2[1]])
    pmin = _point_to_cartesian(layer, Point(minimum(lonextr), minimum(latextr)); side=:bottomleft)
    pmax = _point_to_cartesian(layer, Point(maximum(lonextr), maximum(latextr)); side=:topright)
    R = T <: SimpleSDMResponse ? SimpleSDMResponse : SimpleSDMPredictor
    left = longitudes(layer)[last(pmin.I)]-stride(layer, 1)
    right = longitudes(layer)[last(pmax.I)]+stride(layer, 1)
    bottom = latitudes(layer)[first(pmin.I)]-stride(layer, 2)
    top = latitudes(layer)[first(pmax.I)]+stride(layer, 2)
    return R(
        layer.grid[pmin:pmax],
        left = isapprox(left, round(left)) ? round(left) : left,
        right = isapprox(right, round(right)) ? round(right) : right,
        bottom = isapprox(bottom, round(bottom)) ? round(bottom) : bottom,
        top = isapprox(top, round(top)) ? round(top) : top
    )
end

"""
    clip(layer::T; left=nothing, right=nothing, top=nothing, bottom=nothing) where {T <: SimpleSDMLayer}

Clips a raster by giving the (optional) limites `left`, `right`, `bottom`, and `top`.
"""
function clip(layer::T; left=nothing, right=nothing, top=nothing, bottom=nothing) where {T <: SimpleSDMLayer}
    p1 = Point(
        isnothing(left) ? layer.left : left,
        isnothing(bottom) ? layer.bottom : bottom
    )
    p2 = Point(
        isnothing(right) ? layer.right : right,
        isnothing(top) ? layer.top : top
    )
    return clip(layer, p1, p2)
end

"""
    clip(origin::T1, destination::T2) where {T1 <: SimpleSDMLayer, T2 <: SimpleSDMLayer}

Clips a layer by another layer, *i.e.* subsets the first layer so that it has
the dimensions of the second layer. This operation applies a very small
displacement to the limits (`5eps()`) to ensure that if the coordinate to cut at
falls exactly on a cell boundary, the correct cell will be used in the return
layer.
"""
function clip(origin::T1, destination::T2) where {T1 <: SimpleSDMLayer, T2 <: SimpleSDMLayer}
    _d = 5eps()
    err = false
    destination.right > origin.right && (err = true)
    destination.left < origin.left && (err = true)
    destination.bottom < origin.bottom && (err = true)
    destination.top > origin.top && (err = true)
    err && throw(ArgumentError("The two layers are not compatible"))
    return clip(origin, Point(destination.left+_d, destination.bottom+_d), Point(destination.right-_d, destination.top-_d))
end
