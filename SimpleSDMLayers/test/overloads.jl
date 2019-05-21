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


end
