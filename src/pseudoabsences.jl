abstract type PseudoAbsenceGenerator end

struct WithinRadius <: PseudoAbsenceGenerator
end

struct SurfaceRangeEnvelope <: PseudoAbsenceGenerator
end

struct RandomSelection <: PseudoAbsenceGenerator
end

function _random_point(ref, d; R = 6371.0)
    α = deg2rad(rand() * 360.0)
    return _known_point(ref, d, α; R = R)
end

function _known_point(ref, d, α; R = 6371.0)
    # Convert the coordinates from degrees to radians
    λ, φ = deg2rad.(ref)
    # Get the angular distance
    δ = d / R
    # Get the new latitude
    φ2 = asin(sin(φ) * cos(δ) + cos(φ) * sin(δ) * cos(α))
    # Get the new longitude
    λ2 = λ + atan(sin(α) * sin(δ) * cos(φ), cos(δ) - sin(φ) * sin(φ2))
    # Return the coordinates in degree
    return rad2deg.((λ2, φ2))
end

function _layer_works_for_pseudoabsence(layer::T) where {T <: SimpleSDMLayer}
    @assert SimpleSDMLayers._inner_type(layer) <: Bool
    n_occ = sum(layer)
    return iszero(n_occ) && throw(ArgumentError("The presences layer is empty"))
end

function pseudoabsencemask(
    ::Type{WithinRadius},
    presences::T;
    distance::Number = 100.0,
) where {T <: SimpleSDMLayer}
    _layer_works_for_pseudoabsence(presences)
    presence_only = mask(presences, presences)
    background = similar(presences, Bool)
    keypool = keys(background)
    # We only need to allocate this once, this is going to be written over for every
    # iteration
    lon = zeros(Float64, 4)
    lat = zeros(Float64, 4)
    for occupied_cell in keys(presence_only)
        for (i, angl) in enumerate((0:3) / 4)
            α = deg2rad(360.0angl)
            lon[i], lat[i] = _known_point(occupied_cell, distance, α)
        end
        # Approximate bounding box for the cells to deal with
        max_lat = min(presences.top, maximum(lat))
        min_lat = max(presences.bottom, minimum(lat))
        max_lon = min(presences.right, maximum(lon))
        min_lon = max(presences.left, minimum(lon))
        valid_keys = filter(
            k -> (min_lon <= k[1] <= max_lon) & (min_lat <= k[2] <= max_lat),
            keypool,
        )
        filter!(k -> _distance_function(occupied_cell, k) <= distance, valid_keys)
        for background_cell in valid_keys
            background[background_cell] = true
        end
        deleteat!(keypool, indexin(valid_keys, keypool))
    end
    return background
end

function pseudoabsencemask(
    ::Type{RandomSelection},
    presences::T) where {T <: SimpleSDMLayer}
    _layer_works_for_pseudoabsence(presences)
    presence_only = mask(presences, presences)
    background = replace(similar(presences, Bool), false => true)
    for occupied_cell in keys(presence_only)
        background[occupied_cell] = false
    end
    return background
end

function pseudoabsencemask(
    ::Type{SurfaceRangeEnvelope},
    presences::T) where {T <: SimpleSDMLayer}
    _layer_works_for_pseudoabsence(presences)
    presence_only = mask(presences, presences)
    background = similar(presences, Bool)
    lon = extrema([k[1] for k in keys(presence_only)])
    lat = extrema([k[2] for k in keys(presence_only)])
    for occupied_cell in keys(presences)
        if lon[1] <= occupied_cell[1] <= lon[2]
            if lat[1] <= occupied_cell[2] <= lat[2]
                if ~(presences[occupied_cell])
                    background[occupied_cell] = true
                end
            end
        end
    end
    return background
end

function sample(layer::T, n::Integer = 1; kwargs...) where {T <: SimpleSDMLayer}
    @assert SimpleSDMLayers._inner_type(layer) <: Bool
    pseudoabs = similar(layer, Bool)
    for k in StatsBase.sample(keys(replace(layer, false => nothing)), n; kwargs...)
        pseudoabs[k] = true
    end
    return pseudoabs
end

function sample(
    layer::T,
    weights::T2,
    n::Integer = 1;
    kwargs...,
) where {T <: SimpleSDMLayer, T2 <: SimpleSDMLayer}
    @assert SimpleSDMLayers._inner_type(layer) <: Bool
    @assert SimpleSDMLayers._inner_type(weights) <: Number
    pseudoabs = similar(layer, Bool)
    void = replace(layer, false => nothing)
    vals = weights[keys(void)]
    for k in StatsBase.sample(keys(void), StatsBase.Weights(vals), n; kwargs...)
        pseudoabs[k] = true
    end
    return pseudoabs
end
