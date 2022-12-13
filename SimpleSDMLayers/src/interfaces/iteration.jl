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

Tables.istable(::Type{T}) where {T <: SimpleSDMLayer} = true
Tables.rowaccess(::Type{T}) where {T <: SimpleSDMLayer} = true
Tables.rows(layer::T) where {T <: SimpleSDMLayer} = layer

function _table_to_layer(tabstruct, ::Type{LT}) where {LT <: SimpleSDMLayer}
    lon = tabstruct.longitude
    lat = tabstruct.latitude
    val = tabstruct.value
    lonstride = minimum(diff(unique(sort(lon))))
    latstride = minimum(diff(unique(sort(lat))))
    lonbox = [minimum(lon) - 0.5lonstride, maximum(lon) + 0.5lonstride]
    latbox = [minimum(lat) - 0.5latstride, maximum(lat) + 0.5latstride]
    longrid = length(lonbox[1]:lonstride:lonbox[2])
    latgrid = length(latbox[1]:latstride:latbox[2])
    grid = Matrix{Union{Nothing, eltype(val)}}(nothing, latgrid, longrid)
    layer =
        LT(
            grid;
            left = lonbox[1],
            right = lonbox[2],
            bottom = latbox[1],
            top = latbox[2],
        )
    for r in eachrow(tabstruct)
        layer[r.longitude, r.latitude] = r.value
    end
    return layer
end

Tables.materializer(::Type{T}) where {T <: SimpleSDMLayer} = (t) -> _table_to_layer(t, T)