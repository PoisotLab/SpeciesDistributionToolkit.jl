module SSLTestBasics
using SimpleSDMLayers
using Test

M = rand(Bool, (3,5))
S = SimpleSDMPredictor(M, 0.0, 1.0, 0.0, 1.0)

@test longitudes(S) == range(0.1, 0.9; length=5)
@test latitudes(S) == range(1/6, 5/6; length=3)

M = rand(Bool, (4,3))
S = SimpleSDMPredictor(M, 0.2, 1.8, -1.0, 2.0)

@test longitudes(S) == range(S.left+stride(S,1), S.right-stride(S,1); length=size(S,2))
@test latitudes(S) == range(S.bottom+stride(S,2), S.top-stride(S,2); length=size(S,1))

end
