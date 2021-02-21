module SSLTestRescale
using SimpleSDMLayers
using Test

M1 = rand(Float64, (5, 10)).*4
S1 = SimpleSDMPredictor(M, 0.0, 1.0, 0.0, 1.0)

M2 = (rand(Float64, (5, 10)).+1).*5
S2 = SimpleSDMPredictor(M, 0.0, 1.0, 0.0, 1.0)

@test extrema(rescale(M1, M2)) == extrema(M2)
@test extrema(rescale(M2, M1)) == extrema(M1)

end
