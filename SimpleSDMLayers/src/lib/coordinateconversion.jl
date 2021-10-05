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

    layer.top >= lat >= layer.bottom || return nothing

    relative = (lat - layer.bottom)/(layer.top - layer.bottom)*(size(layer,1))+1
    
    @assert side in [:bottom, :top, :none]

    isequal(:none)(side) && return min(floor(Int, relative), size(layer, 1))
    isequal(:bottom)(side) && return min(floor(Int64, relative), size(layer, 1))
    isequal(:top)(side) && return min(floor(Int64, relative), size(layer, 1))

    #=
    rval = floor(Int64, relative):1:ceil(Int64, relative)

    ldiff = abs.(lat .- latitudes(layer)[rval])
    lapprox = isapprox.(ldiff, stride(layer, 2))

    if side == :none || !any(lapprox)
        l = last(findmin(ldiff))
    elseif side == :bottom
        l = findlast(lapprox)
    elseif side == :top
        l = findfirst(lapprox)
    else
        throw(ArgumentError("side must be one of :none (default), :bottom, :top"))
    end
    
    return rval[l]
    =#
end

function _match_longitude(layer::T, lon::K; side::Symbol=:none) where {T <: SimpleSDMLayer, K <: AbstractFloat}
    
    layer.right >= lon >= layer.left || return nothing
    
    relative = (lon - layer.left)/(layer.right - layer.left)*(size(layer,2))+1    
    
    @assert side in [:left, :right, :none]

    isequal(:none)(side) && return min(floor(Int, relative), size(layer, 2))
    isequal(:left)(side) && return min(floor(Int64, relative), size(layer, 2))
    isequal(:right)(side) && return min(floor(Int64, relative), size(layer, 2))

    #=
    rval = floor(Int64, relative):1:ceil(Int64, relative)

    ldiff = abs.(lon .- longitudes(layer)[rval])
    lapprox = isapprox.(ldiff, stride(layer, 1))
    
    if side == :none || !any(lapprox)
        l = last(findmin(ldiff))
    elseif side == :left
        l = findlast(lapprox)
    elseif side == :right
        l = findfirst(lapprox)
    else
        throw(ArgumentError("side must be one of :none (default), :left, :right"))
    end

    return rval[l]
    =#
end