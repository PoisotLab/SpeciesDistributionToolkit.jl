"""
    PseudoAbsenceGenerator

Abstract type to which all of the pseudo-absences generator types belong. Note
that the pseudo-absence types are *singleton* types, and the arguments are
passed when generating the pseudo-absence mask.
"""
abstract type PseudoAbsenceGenerator end

"""
    WithinRadius

Generates pseudo-absences within a set radius (in kilometers) around each
occurrence
"""
struct WithinRadius <: PseudoAbsenceGenerator
end

"""
    SurfaceRangeEnvelope

Generates pseudo-absences at random within the geographic range covered by
actual occurrences
"""
struct SurfaceRangeEnvelope <: PseudoAbsenceGenerator
end

"""
    RandomSelection

Generates pseudo-absences at random within the layer
"""
struct RandomSelection <: PseudoAbsenceGenerator
end

"""
    DistanceToEvent

Generates a weight for the pseudo-absences based on the distance to cells with a `true` value
"""
struct DistanceToEvent <: PseudoAbsenceGenerator
end

"""
    _random_point(ref, d; R = 6371.0)

This function is used _internally_ to create a random point located within a distance `d` of point `ref`, assuming that the radius of the Earth is `R`. All it does is to generate a random angle in degrees, and the using the `_known_point` method to generate the new point.
"""
function _random_point(ref, d; R = 6371.0)
    α = deg2rad(rand() * 360.0)
    return _known_point(ref, d, α; R = R)
end

"""
    _known_point(ref, d, α; R = 6371.0)

This function will generate a new point set at a distance `d` and angle `α` from the `ref` point, assuming the radius of the Earth is `R`.
"""
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

function _layer_works_for_pseudoabsence(layer::SDMLayer{T}) where {T <: Bool}
    iszero(sum(layer)) && throw(ArgumentError("The presences layer is empty"))
    return nothing
end

"""
    pseudoabsencemask(::Type{RandomSelection}, presence::T) where {T <: SDMLayer}

Generates a mask for pseudo-absences using the random selection method. Candidate
cells for the pseudo-absence mask are (i) within the bounding box of the _layer_
(use `SurfaceRangeEnvelope` to use the presences bounding box), and (ii) valued in the
layer.
"""
function pseudoabsencemask(::Type{RandomSelection}, presences::T) where {T <: SDMLayer}
    _layer_works_for_pseudoabsence(presences)
    return !presences
end

"""
    pseudoabsencemask( ::Type{SurfaceRangeEnvelope}, presences::T) where {T <: SDMLayer}

Generates a mask from which pseudo-absences can be drawn, by picking cells that
are (i) within the bounding box of occurrences, (ii) valued in the layer, and
(iii) not already occupied by an occurrence
"""
function pseudoabsencemask(::Type{SurfaceRangeEnvelope}, presences::T) where {T <: SDMLayer}
    _layer_works_for_pseudoabsence(presences)
    presence_only = nodata(presences, false)
    background = zeros(presences, Bool)
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

"""
    pseudoabsencemask(::Type{DistanceToEvent}, presence::T; f=minimum) where {T <: SimpleSDMLayer}

Generates a mask for pseudo-absences using the distance to event method.
Candidate cells are weighted according to their distance to a known observation,
with far away places being more likely. Depending on the distribution of
distances, it may be a very good idea to flatten this layer using `log` or an
exponent. The `f` function is used to determine which distance is reported
(minimum by default, can also be mean or median).
"""
function pseudoabsencemask(
    ::Type{DistanceToEvent},
    presences::T;
    f = minimum,
) where {T <: SDMLayer}
    _layer_works_for_pseudoabsence(presences)
    presence_only = nodata(presences, false)
    background = zeros(presences, Float64)

    d = SpeciesDistributionToolkit.Fauxcurrences._distancefunction

    prj = SimpleSDMLayers.Proj.Transformation(presences.crs, "+proj=longlat +datum=WGS84 +no_defs"; always_xy = true)
    E, N = eastings(presences), northings(presences)

    points = [prj(E[i.I[2]], N[i.I[1]]) for i in keys(presence_only)]

    for k in keys(background)
        pk = prj(E[k.I[2]], N[k.I[1]])
        background[k] = f([d(pk, ko) for ko in points])
    end

    return background
end

function pseudoabsencemask(
    ::Type{WithinRadius},
    presences::T;
    distance::Number = 100.0,
) where {T <: SDMLayer}
    _layer_works_for_pseudoabsence(presences)

    bg = pseudoabsencemask(DistanceToEvent, presences; f = minimum)
    background = bg .<= distance
    for i in keys(nodata(presences, false))
        background[i] = false
    end
    return background
end

"""
    backgroundpoints(layer::T, n::Int; replace::Bool=false, kwargs...) where {T <: SimpleSDMLayer}

Generates background points based on a layer that gives either the location of
possible points (`Bool`) or the weight of each cell in the final sample
(`Number`). Note that the default value is to draw without replacement, but this
can be changed using `replace=true`. The additional keywors arguments are passed
to `StatsBase.sample`, which is used internally.
"""
function backgroundpoints(
    layer::T,
    n::Int;
    kwargs...
) where {T <: SDMLayer}
    background = zeros(layer, Bool)
    selected_points = StatsBase.sample(
        keys(layer),
        StatsBase.Weights(values(layer)),
        n;
        kwargs...,
    )
    for sp in selected_points
        background[sp] = true
    end
    return background
end
