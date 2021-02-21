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

@test typeof(S[left=0.2, right=0.6, bottom=0.5, top=1.0]) == typeof(S)
@test S[left=0.2, right=0.6, bottom=0.5, top=1.0].top ≈ 1.0
@test S[left=0.2, right=0.6, bottom=0.5, top=1.0].bottom ≈ 0.4
@test S[left=0.2, right=0.6, bottom=0.5, top=1.0].right ≈ 0.6
@test S[left=0.2, right=0.6, bottom=0.5, top=1.0].left ≈ 0.2

@test typeof(S[left=0.2, bottom=0.5]) == typeof(S)
@test S[left=0.2, bottom=0.5].top ≈ 1.0
@test S[left=0.2, bottom=0.5].bottom ≈ 0.4
@test S[left=0.2, bottom=0.5].right ≈ 1.0
@test S[left=0.2, bottom=0.5].left ≈ 0.2

C = (left=0.2, bottom=0.5)
@test typeof(S[C]) == typeof(S)

Y = SimpleSDMResponse(zeros(Float64, (5,5)), 0.0, 1.0, 0.0, 1.0)
Y[0.1,0.1] = 0.2
@test Y[0.1,0.1] == 0.2

Z = convert(SimpleSDMPredictor, Y)
Y[0.1,0.1] = 4.0
@test Z[0.1,0.1] != Y[0.1,0.1]
@test Z[0.1,0.1] == 0.2

Z = convert(SimpleSDMPredictor, Y)
V = collect(Z)
@test typeof(V) == Vector{Float64}

# hcat / vcat
l1 = worldclim(1, left=0.0, right=10.0, bottom=0.0, top=10.0)
l2 = worldclim(1, left=0.0, right=10.0, bottom=10.0, top=20.0)
l3 = worldclim(1, left=10.0, right=20.0, bottom=0.0, top=10.0)
l4 = worldclim(1, left=10.0, right=20.0, bottom=10.0, top=20.0)

ml1 = hcat(l1, l3)
vl1 = vcat(l1, l2)
ml2 = hcat(l2, l4)
vl2 = vcat(l3, l4)

@test all(vcat(ml1, ml2).grid == hcat(vl1, vl2).grid)

# typed similar
c2 = similar(Bool, l1)
@test eltype(c2) == Union{Nothing,Bool}

end
