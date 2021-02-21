module SSLTestRescale
using SimpleSDMLayers
using Test

M1 = rand(Float64, (5, 10)).*4
S1 = SimpleSDMPredictor(M1, 0.0, 1.0, 0.0, 1.0)

M2 = (rand(Float64, (5, 10)).+1).*5
S2 = SimpleSDMPredictor(M2, 0.0, 1.0, 0.0, 1.0)

@test extrema(rescale(S1, S2)) == extrema(S2)
@test extrema(rescale(S2, S1)) == extrema(S1)

rescale!(S1, [0.0, 0.5, 1.0])
@test sort(unique(collect(S1))) == [0.0, 0.5, 1.0]

end
