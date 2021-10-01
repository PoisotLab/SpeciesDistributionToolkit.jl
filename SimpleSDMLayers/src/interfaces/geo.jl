struct RasterCoordinate{T} <: AbstractPoint where {T <: Real}
    longitude::T
    latitude::T
end

GeoInterface.xcoord(c::RasterCoordinate) = c.longitude
GeoInterface.ycoord(c::RasterCoordinate) = c.latitude
GeoInterface.hasz(::RasterCoordinate) = false