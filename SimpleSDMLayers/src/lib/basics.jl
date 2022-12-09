"""
    latitudes(layer::T) where {T <: SimpleSDMLayer}

Returns an iterator with the latitudes of the SDM layer passed as its argument.
This returns the latitude at the center of each cell in the grid.
"""
latitudes(layer::T) where {T <: SimpleSDMLayer} = range(
    layer.bottom + stride(layer, 2),
    layer.top - stride(layer, 2);
    length = size(layer, 1),
)

"""
    longitudes(layer::T) where {T <: SimpleSDMLayer}

Returns an iterator with the longitudes of the SDM layer passed as its argument.
This returns the longitudes at the center of each cell in the grid.
"""
longitudes(layer::T) where {T <: SimpleSDMLayer} = range(
    layer.left + stride(layer, 1),
    layer.right - stride(layer, 1);
    length = size(layer, 2),
)

"""
    boundingbox(layer::T) where {T <: SimpleSDMLayer}

Returns the bounding coordinates of a layer as `NamedTuple`.
"""
boundingbox(layer::T) where {T <: SimpleSDMLayer} =
    (left = layer.left, right = layer.right, bottom = layer.bottom, top = layer.top)

"""
    _layers_are_compatible(l1::X, l2::Y) where {X <: SimpleSDMLayer, Y <: SimpleSDMLayer}

    Internal function to verify if layers are compatible, i.e. have the same
    size and bounding coordinates.
"""
function _layers_are_compatible(
    l1::X,
    l2::Y,
) where {X <: SimpleSDMLayer, Y <: SimpleSDMLayer}
    size(l1) == size(l2) || throw(ArgumentError("The layers have different sizes"))
    l1.top == l2.top || throw(ArgumentError("The layers have different top coordinates"))
    l1.left == l2.left || throw(ArgumentError("The layers have different left coordinates"))
    l1.bottom == l2.bottom ||
        throw(ArgumentError("The layers have different bottom coordinates"))
    return l1.right == l2.right ||
           throw(ArgumentError("The layers have different right coordinates"))
end

function _layers_are_compatible(layers::Array{T}) where {T <: SimpleSDMLayer}
    return all(layer -> _layers_are_compatible(layer, layers[1]), layers)
end

function grid(layer::T) where {T <: SimpleSDMLayer}
    return copy(layer.grid)
end

"""
    cellsize(layer::SimpleSDMLayer)

Returns a layer of the same type (predictor or response) where the value of each cell is the surface area of this cell assuming that the Earth is round (not "round as opposed to flat", but "round as opposed to potato shaped").

In practice, this function works by measuring the area of the spherical cap at the top and bottom of each cell, then subtracting one from the other, to get the area of the *ribbon* for this range of latitudes. This is divided by the number of cells needed to cover the entire ribbon, which is given by the ratio between the longitudinal size of each cell and 360 (being the breadth of possible longitudes).
"""
function cellsize(layer::T; R = 6371.0) where {T <: SimpleSDMLayer}
    lonstride, latstride = 2.0 .* stride(layer)
    cells_per_ribbon = 360.0 / lonstride
    latitudes_ranges = (layer.bottom):latstride:(layer.top)
    # We need to express the latitudes in gradients for the top and bottom of each row of
    # cell
    ϕ1 = deg2rad.(latitudes_ranges[1:(end - 1)])
    ϕ2 = deg2rad.(latitudes_ranges[2:end])
    # The difference between the sin of each is what we want to get the area
    Δ = abs.(sin.(ϕ1)) .- abs.(sin.(ϕ2))
    A = 2π * (R^2.0) .* Δ
    cell_surface = A ./ cells_per_ribbon
    # We then reshape everything to a grid
    surface_grid = reshape(repeat(cell_surface, size(layer, 2)), size(layer))
    # And we return based on the actual type of the input
    RT = T <: SimpleSDMResponse ? SimpleSDMResponse : SimpleSDMPredictor
    return RT(surface_grid; SimpleSDMLayers.boundingbox(layer)...)
end
