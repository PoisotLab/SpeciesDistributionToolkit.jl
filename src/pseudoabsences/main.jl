abstract type PseudoAbsenceGenerator end

struct WithinRadius <: PseudoAbsenceGenerator
end

struct SurfaceRangeEnvelope <: PseudoAbsenceGenerator
end

struct RandomSelection <: PseudoAbsenceGenerator
end
