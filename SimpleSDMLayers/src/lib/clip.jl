"""
    clip(layer::T, p1::Point, p2::Point; expand=Symbol[]) where {T <: SimpleSDMLayer}

Return a raster by defining a bounding box through two points. The order of the
points (in terms of bottom/top/left/right) is not really important, as the
correct coordinates will be extracted.

**This method is the one that other versions of `clip` ultimately end up
calling**.

This operation takes an additional keyword argument `expand`, which is a vector
of `Symbol`s, the symbols being any combination of `:left`, `:right`, `:bottom`,
and `:top`. This argument specifies, in the case where the coordinate to clip is
at the limit between two cells in a raster, whether the outer neighboring
row/column should be included. This defaults to `expand=Symbol[]`, *i.e.* the
outer neighboring cell will *not* be included.
"""
function clip(
    layer::T,
    p1::Point,
    p2::Point;
    expand = Symbol[],
) where {T <: SimpleSDMLayer}
    # Find the new bounding box for the clipped layer
    bottom, top = extrema([p1[2], p2[2]])
    left, right = extrema([p1[1], p2[1]])

    # Get the boundaries between pixels
    lon_boundaries = LinRange(layer.left, layer.right, size(layer, 2) + 1)
    lat_boundaries = LinRange(layer.bottom, layer.top, size(layer, 1) + 1)

    # Left to cell coordinate
    left_cell = findlast(lon_boundaries .<= left)
    if left == lon_boundaries[left_cell]
        if :left in expand
            left_cell = max(1, left_cell - 1)
        end
    end

    # Right to cell coordinate
    right_cell = findfirst(lon_boundaries .>= right)
    if right == lon_boundaries[right_cell]
        if :right in expand
            right_cell = min(size(layer, 2) + 1, right_cell + 1)
        end
    end

    # Bottom to cell coordinate
    bottom_cell = findlast(lat_boundaries .<= bottom)
    if bottom == lat_boundaries[bottom_cell]
        if :bottom in expand
            bottom_cell = max(1, bottom_cell - 1)
        end
    end

    # Top to cell coordinate
    top_cell = findfirst(lat_boundaries .>= top)
    if top == lat_boundaries[top_cell]
        if :top in expand
            top_cell = min(size(layer, 1) + 1, top_cell + 1)
        end
    end

    # New grid
    newgrid = layer.grid[bottom_cell:(top_cell - 1), left_cell:(right_cell - 1)]

    # New return type
    RT = typeof(layer) <: SimpleSDMResponse ? SimpleSDMResponse : SimpleSDMPredictor

    # Return with the correct bounding box
    return RT(
        newgrid;
        left = lon_boundaries[left_cell],
        right = lon_boundaries[right_cell],
        bottom = lat_boundaries[bottom_cell],
        top = lat_boundaries[top_cell],
    )
end

"""
    clip(layer::T; left=nothing, right=nothing, top=nothing, bottom=nothing, kwargs...) where {T <: SimpleSDMLayer}

Clips a raster by giving the (optional) limits `left`, `right`, `bottom`, and
`top`.

This operation takes an additional keyword argument `expand`, which is a vector
of `Symbol`s, the symbols being any combination of `:left`, `:right`, `:bottom`,
and `:top`. This argument specifies, in the case where the coordinate to clip is
at the limit between two cells in a raster, whether the outer neighboring
row/column should be included. This defaults to `expand=Symbol[]`, *i.e.* the
outer neighboring cell will *not* be included.
"""
function clip(
    layer::T;
    left = nothing,
    right = nothing,
    top = nothing,
    bottom = nothing,
    kwargs...,
) where {T <: SimpleSDMLayer}
    p1 = Point(
        isnothing(left) ? layer.left : left,
        isnothing(bottom) ? layer.bottom : bottom,
    )
    p2 = Point(
        isnothing(right) ? layer.right : right,
        isnothing(top) ? layer.top : top,
    )
    return clip(layer, p1, p2; kwargs...)
end

"""
    clip(origin::T1, destination::T2; kwargs...) where {T1 <: SimpleSDMLayer, T2 <: SimpleSDMLayer}

Clips a layer by another layer, *i.e.* subsets the first layer so that it has
the dimensions of the second layer.

This operation takes an additional keyword argument `expand`, which is a vector
of `Symbol`s, the symbols being any combination of `:left`, `:right`, `:bottom`,
and `:top`. This argument specifies, in the case where the coordinate to clip is
at the limit between two cells in a raster, whether the outer neighboring
row/column should be included. This defaults to `expand=Symbol[]`, *i.e.* the
outer neighboring cell will *not* be included.
"""
function clip(
    origin::T1,
    destination::T2;
    kwargs...,
) where {T1 <: SimpleSDMLayer, T2 <: SimpleSDMLayer}
    err = false
    destination.right > origin.right && (err = true)
    destination.left < origin.left && (err = true)
    destination.bottom < origin.bottom && (err = true)
    destination.top > origin.top && (err = true)
    err && throw(ArgumentError("The two layers are not compatible"))
    return clip(
        origin,
        Point(destination.left, destination.top),
        Point(destination.right, destination.bottom);
        kwargs...,
    )
end
