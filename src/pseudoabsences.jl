abstract type PseudoAbsenceGenerator end

struct WithinRadius <: PseudoAbsenceGenerator
end

struct SurfaceRangeEnvelope <: PseudoAbsenceGenerator
end

struct RandomSelection <: PseudoAbsenceGenerator
end

function _random_point(ref, d; R = 6371.0)
    # Convert the coordinates from degrees to radians
    λ, φ = deg2rad.(ref)
    # Get the angular distance
    δ = d / R
    # Pick a random bearing (angle w.r.t. true North)
    α = deg2rad(rand() * 360.0)
    # Get the new latitude
    φ2 = asin(sin(φ) * cos(δ) + cos(φ) * sin(δ) * cos(α))
    # Get the new longitude
    λ2 = λ + atan(sin(α) * sin(δ) * cos(φ), cos(δ) - sin(φ) * sin(φ2))
    # Return the coordinates in degree
    return rad2deg.((λ2, φ2))
end

function _invalid_pseudoabsence(pt, msk)
    isnothing(msk[pt...]) && return true
    msk[pt...] && return true
    return false
end

function _layer_works_for_pseudoabsence(layer::T) where {T <: SimpleSDMLayer}
    @assert SimpleSDMLayers._inner_type(layer) <: Bool
    n_occ = sum(layer)
    return iszero(n_occ) && throw(ArgumentError("The presences layer is empty"))
end

function _return_point_as_grid(pt, layer)
    cart = SimpleSDMLayers._point_to_cartesian(layer, Point(pt...))
    rtpt = Point((longitudes(layer)[cart[2]], latitudes(layer)[cart[1]]))
    return rtpt
end

"""
    pseudoabsence

This method generates a possible pseudo-absence location around known observations in a Boolean layer. The observations are generated in a radius expressed in *kilometers* around the known presences. To generate many background points, call this method multiple times.
"""
function pseudoabsence(
    ::Type{WithinRadius},
    presences::T;
    distance::Number = 100.0,
) where {T <: SimpleSDMLayer}
    _layer_works_for_pseudoabsence(presences)
    k = rand(keys(presences))
    newpt = _random_point(k, sqrt(rand()) * distance)
    while _invalid_pseudoabsence(newpt, presences)
        newpt = _random_point(k, sqrt(rand()) * distance)
    end
    return _return_point_as_grid(newpt, presences)
end

function pseudoabsence(
    ::Type{SurfaceRangeEnvelope},
    presences::T,
) where {T <: SimpleSDMLayer}
    _layer_works_for_pseudoabsence(presences)
    bbox = SpeciesDistributionToolkit.boundingbox(replace(presences, false => nothing))
    londist = Distributions.Uniform(bbox.left, bbox.right)
    latdist = Distributions.Uniform(bbox.bottom, bbox.top)
    newpt = (rand(londist), rand(latdist))
    while _invalid_pseudoabsence(newpt, presences)
        newpt = (rand(londist), rand(latdist))
    end
    return _return_point_as_grid(newpt, presences)
end

function pseudoabsence(
    ::Type{RandomSelection},
    presences::T,
) where {T <: SimpleSDMLayer}
    _layer_works_for_pseudoabsence(presences)
    bbox = SpeciesDistributionToolkit.boundingbox(presences)
    londist = Distributions.Uniform(bbox.left, bbox.right)
    latdist = Distributions.Uniform(bbox.bottom, bbox.top)
    newpt = (rand(londist), rand(latdist))
    while _invalid_pseudoabsence(newpt, presences)
        newpt = (rand(londist), rand(latdist))
    end
    return _return_point_as_grid(newpt, presences)
end
