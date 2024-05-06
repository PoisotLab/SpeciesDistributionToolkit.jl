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
    Base.length(layer::T)

Number of elements in the grid that are not nothing
"""
Base.length(layer::T) where {T <: SimpleSDMLayer} = count(!isnothing, layer.grid)

"""
    Base.keys(layer::T) where {T <: SimpleSDMLayer}

Returns an array of `Point` where every entry in the array is a non-`nothing`
grid coordinate.
"""
function Base.keys(layer::T) where {T <: SimpleSDMLayer}
    _lon = longitudes(layer)
    _lat = latitudes(layer)
    return [Point(_lon[p[2]], _lat[p[1]]) for p in findall(!isnothing, layer.grid)]
end