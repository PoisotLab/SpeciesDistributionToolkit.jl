function _point_to_cartesian(layer::T, c::Point; side=:center) where {T <: SimpleSDMLayer}
    lonside, latside = :none, :none
    if side == :bottomleft
        lonside, latside = :left, :bottom
    end
    if side == :topright
        lonside, latside = :right, :top
    end
    lon = SimpleSDMLayers._match_longitude(layer, c[1]; side=lonside)
    lat = SimpleSDMLayers._match_latitude(layer, c[2]; side=latside)
    isnothing(lon) && return nothing
    isnothing(lat) && return nothing
    return CartesianIndex(lat, lon)
end

function _match_latitude(layer::T, lat::K; side=:none) where {T <: SimpleSDMLayer, K <: AbstractFloat}
    side in [:none, :bottom, :top] || throw(ArgumentError("side must be one of :none (default), :bottom, :top"))

    lat > layer.top && return nothing
    lat < layer.bottom && return nothing

    ldiff = abs.(lat .- latitudes(layer))
    lapprox = isapprox.(ldiff, stride(layer, 2))
    if side == :none || !any(lapprox)
        l = last(findmin(ldiff))
    elseif side == :bottom
        l = findlast(lapprox)
    elseif side == :top
        l = findfirst(lapprox)
    end
    
    return l
end

function _match_longitude(layer::T, lon::K; side::Symbol=:none) where {T <: SimpleSDMLayer, K <: AbstractFloat}
    side in [:none, :left, :right] || throw(ArgumentError("side must be one of :none (default), :left, :right"))
    
    lon > layer.right && return nothing
    lon < layer.left && return nothing
    
    ldiff = abs.(lon .- longitudes(layer))
    lapprox = isapprox.(ldiff, stride(layer, 1))
    if side == :none || !any(lapprox)
        l = last(findmin(ldiff))
    elseif side == :left
        l = findlast(lapprox)
    elseif side == :right
        l = findfirst(lapprox)
    end

    return l
end