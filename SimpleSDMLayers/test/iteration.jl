module SSLTestIteration
using SimpleSDMLayers
using Test

S = SimpleSDMPredictor([1 2 3; 4 5 6; 7 nothing 9], 0.0, 1.0, 0.0, 1.0)

val = sort([v for v in S])
@test all(val .== vec([1 2 3 4 5 6 7 9]))
@test all(val .== sort(collect(S)))

end