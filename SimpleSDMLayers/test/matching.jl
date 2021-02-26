module SSLTestMatching
using SimpleSDMLayers
using Test

M = rand(Bool, 6, 9)

S = SimpleSDMPredictor(M, rand(), 4rand(), 3rand(), 16rand())

@test SimpleSDMLayers._match_latitude(S, S.bottom) == 1
@test SimpleSDMLayers._match_latitude(S, S.top) == 6
@test SimpleSDMLayers._match_longitude(S, S.left) == 1
@test SimpleSDMLayers._match_longitude(S, S.right) == 9

S = SimpleSDMResponse(rand(Bool, 4, 4), 0.3, 0.7, 0.5, 0.9)

@test SimpleSDMLayers._match_latitude(S, 0.2) === nothing
@test SimpleSDMLayers._match_latitude(S, 1.8) === nothing
@test SimpleSDMLayers._match_latitude(S, 0.5) == 1
for (i,l) in enumerate(latitudes(S))
    @test SimpleSDMLayers._match_latitude(S, l) == i
end

end