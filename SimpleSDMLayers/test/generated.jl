module SSLTestGenerated
using SimpleSDMLayers
using Test

M = rand(Float64, (5, 10))
S = SimpleSDMPredictor(M, 0.0, 1.0, 0.0, 1.0)

@test maximum(S) ≤ 1.0
@test minimum(S) ≥ 0.0

using Statistics

@test mean(S) == mean(M)
@test std(S) == std(M)
@test median(S) == median(M)

end
