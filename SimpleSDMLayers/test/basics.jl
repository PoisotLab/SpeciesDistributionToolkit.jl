module SSLTestBasics
using SimpleSDMLayers
using Test

M = rand(Bool, (3,5))
S = SimpleSDMPredictor(M, 0.0, 1.0, 0.0, 1.0)

@assert longitudes(S) == 0.1:0.2:0.9
@assert latitudes(S) == (1/6):(1/3):(5/6)

end
