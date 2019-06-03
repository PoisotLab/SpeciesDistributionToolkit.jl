module SSLTestOverloads
using SimpleSDMLayers
using Test

M = rand(Bool, (5, 10))
S = SimpleSDMPredictor(M, 0.0, 1.0, 0.0, 1.0)

for i in eachindex(M)
   @test S[i] == M[i]
end
for i in eachindex(S)
   @test S[i] == M[i]
end


@test typeof(S[0.2, 0.6]) == eltype(M)
@test isnan(S[1.2, 0.3])
@test isnan(S[1.2, 1.3])
@test isnan(S[0.2, 1.3])

@test typeof(S[1:2, 5:7]) == typeof(S)

@test typeof(S[(0.2, 0.6), (0.5, 1.0)]) == typeof(S)
@test S[(0.2, 0.6), (0.5, 0.9)].bottom ≤ 0.5
@test S[(0.2, 0.6), (0.5, 0.9)].top ≥ 0.9
@test S[(0.2, 0.6), (0.5, 0.9)].left ≤ 0.2
@test S[(0.2, 0.6), (0.5, 0.9)].right ≥ 0.6
@test_throws ArgumentError S[(-1.0, 0.2), (0.3, 0.8)]

end
