module SSLTestMatching
using SimpleSDMLayers
using Test

M = rand(Bool, 6, 9)

S = SimpleSDMPredictor(M, rand(), 4rand(), 3rand(), 16rand())

@test SimpleSDMLayers._match_latitude(S, S.bottom) == 1
@test SimpleSDMLayers._match_latitude(S, S.top) == 6
@test SimpleSDMLayers._match_longitude(S, S.left) == 1
@test SimpleSDMLayers._match_longitude(S, S.right) == 9

end