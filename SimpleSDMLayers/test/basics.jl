module SSLTestBasics
using SimpleSDMLayers
using Test

M = rand(Bool, (3,5))
S = SimpleSDMPredictor(M, 0.0, 1.0, 0.0, 1.0)

@assert longitudes(S) == LinRange(0.1, 0.9, 5)
@assert latitudes(S) == LinRange(1/6, 5/6, 3)

M = rand(Bool, (4,3))
S = SimpleSDMPredictor(M, 0.2, 1.8, -1.0, 2.0)

@assert longitudes(S) == LinRange(S.left+stride(S,1), S.right-stride(S,1), size(S,2))
@assert latitudes(S) == LinRange(S.bottom+stride(S,2), S.top-stride(S,2), size(S,1))

end
