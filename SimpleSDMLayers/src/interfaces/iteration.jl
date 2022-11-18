struct RasterCell{L <: Number, T <: Any}
    longitude::L
    latitude::L
    value::T
end

function RasterCell(layer::T, position) where {T <: SimpleSDMLayer}
    lon = longitudes(layer)[last(position.I)]
    lat = latitudes(layer)[first(position.I)]
    val = layer.grid[position]
    return RasterCell(lon, lat, val)
end

Base.IteratorSize(::T) where {T <: SimpleSDMLayer} = Base.HasLength()
function Base.IteratorEltype(layer::T) where {T <: SimpleSDMLayer}
    return RasterCell{eltype(latitudes(layer)), SimpleSDMLayers._inner_type(layer)}
end

function Base.iterate(layer::T) where {T <: SimpleSDMLayer}
    position = findfirst(!isnothing, layer.grid)
    isnothing(position) && return nothing
    return (RasterCell(layer, position), position)
end

function Base.iterate(layer::T, state) where {T <: SimpleSDMLayer}
    newstate = LinearIndices(layer.grid)[state] + 1
    newstate > prod(size(layer.grid)) && return nothing
    position = findnext(!isnothing, layer.grid, CartesianIndices(layer.grid)[newstate])
    isnothing(position) && return nothing
    return (RasterCell(layer, position), position)
end
