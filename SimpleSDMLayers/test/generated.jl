module SSLTestGenerated
using SimpleSDMLayers
using Test

M = rand(Float64, (5, 10))
S = SimpleSDMPredictor(M, 0.0, 1.0, 0.0, 1.0)

@test maximum(S) ≤ 1.0
@test minimum(S) ≥ 0.0
@test extrema(S) == (minimum(S), maximum(S))

using Statistics

@test mean(S) ≈ mean(M)
@test std(S) ≈ std(M)
@test median(S) ≈ median(M)

M = ones(Float64, (5, 10))
S = SimpleSDMPredictor(M, 0.0, 1.0, 0.0, 1.0)
@test typeof(sqrt(S)) <: SimpleSDMLayer

S1 = SimpleSDMResponse([-1 0 1 nothing], 0.0, 1.0, 0.0, 1.0)
S2 = SimpleSDMPredictor([Float32.([-2.0 1.0 1.0])... nothing], 0.0, 1.0, 0.0, 1.0)
Sx = [S1, S2]
@test reduce(min, Sx).grid == [-2 0 1 nothing]
@test mean(Sx).grid == [Float32.([-1.5 0.5 1.0])... nothing]
@test reduce(+, Sx).grid == [-3 1 2 nothing]

end
