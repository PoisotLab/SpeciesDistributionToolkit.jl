"""
    clip(layer::T, p1::Point, p2::Point) where {T <: SimpleSDMLayer}

Return a raster by defining a bounding box through two points. The order of the
points (in terms of bottom/top/left/right) is not really important, as the
correct coordinates will be extracted.
"""
function clip(layer::T, p1::Point, p2::Point) where {T <: SimpleSDMLayer}
    latextr = extrema([p1[2], p2[2]])
    lonextr = extrema([p1[1], p2[1]])
    pmin = _point_to_cartesian(layer, Point(minimum(lonextr), minimum(latextr)))
    pmax = _point_to_cartesian(layer, Point(maximum(lonextr), maximum(latextr)))
    R = T <: SimpleSDMResponse ? SimpleSDMResponse : SimpleSDMPredictor
    return R(
        layer.grid[pmin:pmax], 
        longitudes(layer)[last(pmin.I)]-stride(layer, dims=1),
        longitudes(layer)[last(pmax.I)]+stride(layer, dims=1),
        latitudes(layer)[first(pmin.I)]-stride(layer, dims=2),
        latitudes(layer)[first(pmax.I)]+stride(layer, dims=2)
    )
end

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