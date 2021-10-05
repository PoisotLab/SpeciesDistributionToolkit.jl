function _point_to_cartesian(layer::T, c::Point; side=:center) where {T <: SimpleSDMLayer}
    lonside, latside = true, true
    if side == :bottomleft
        lonside, latside = true, true
    end
    if side == :topright
        lonside, latside = false, false
    end
    lon = SimpleSDMLayers._match_longitude(layer, c[1]; lower=lonside)
    lat = SimpleSDMLayers._match_latitude(layer, c[2]; lower=latside)
    isnothing(lon) && return nothing
    isnothing(lat) && return nothing
    return CartesianIndex(lat, lon)
end

function _match_latitude(layer::T, lat::K; lower::Bool=true) where {T <: SimpleSDMLayer, K <: AbstractFloat}
    layer.bottom <= lat <= layer.top || return nothing
    lat == layer.bottom  && return 1
    lat == layer.top  && return size(layer, 1)
    relative = (lat - layer.bottom)/(layer.top - layer.bottom)
    fractional = relative * size(layer, 1)+1
    if lat in layer.bottom:2stride(layer,2):layer.top
        f = lower ? floor : ceil
        d = lower ? 1 : 0
        return min(f(Int64, fractional-d), size(layer, 1))
    else
        return min(floor(Int, fractional), size(layer, 1))
    end
end

function _match_longitude(layer::T, lon::K; lower::Bool=true) where {T <: SimpleSDMLayer, K <: AbstractFloat}
    layer.left <= lon <= layer.top || return nothing
    lon == layer.left  && return 1
    lon == layer.right  && return size(layer, 2)
    relative = (lon - layer.left)/(layer.right - layer.left)
    fractional = relative * size(layer, 2)+1
    if lon in layer.left:2stride(layer,1):layer.right
        f = lower ? floor : ceil
        d = lower ? 1 : 0
        return min(f(Int64, fractional-d), size(layer, 2))
    else
        return min(floor(Int, fractional), size(layer, 2))
    end
end