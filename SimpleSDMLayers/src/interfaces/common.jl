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

Base.length(layer::T) where {T <: SimpleSDMLayer} = count(!isnothing, layer.grid)