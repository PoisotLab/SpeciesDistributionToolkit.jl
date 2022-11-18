module SSLTestIteration
using SimpleSDMLayers
using Test

S = SimpleSDMPredictor([1 2 3; 4 5 6; 7 nothing 9], 0.0, 1.0, 0.0, 1.0)

val = [v for v in S]
@test eltype(val) <: RasterCell
@test length(val) == length(S)

end
