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
occurrence. Internally, this relies on `DistanceToEvent`.
"""
struct WithinRadius <: PseudoAbsenceGenerator
end

"""
    SurfaceRangeEnvelope

Generates pseudo-absences at random within the geographic range covered by
actual occurrences. Cells with presences cannot be part of the background
sample.
"""
struct SurfaceRangeEnvelope <: PseudoAbsenceGenerator
end

"""
    RandomSelection

Generates pseudo-absences at random within the layer. The full extent is
considered, and cells with a true value cannot be part of the background sample.
"""
struct RandomSelection <: PseudoAbsenceGenerator
end

"""
    DistanceToEvent

Generates a weight for the pseudo-absences based on the distance to cells with a
`true` value. The distances are always measured in km using the haversine
formula.
"""
struct DistanceToEvent <: PseudoAbsenceGenerator
end

"""
    DegreesToEvent

Generates a weight for the pseudo-absences based on the distance to cells with a
`true` value. The distances are measured as the Euclidean distance expressed in
degrees around the point.
"""
struct DegreesToEvent <: PseudoAbsenceGenerator
end