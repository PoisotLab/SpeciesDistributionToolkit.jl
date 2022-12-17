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

@test typeof(S[0.2, 0.6]) == SimpleSDMLayers._inner_type(M)
@test S[0.2, 0.6] == S[Point(0.2, 0.6)]
@test isnothing(S[1.2, 0.3])
@test isnothing(S[1.2, 1.3])
@test isnothing(S[0.2, 1.3])

C = (left = 0.2, bottom = 0.5)
@test typeof(clip(S; C...)) == typeof(S)

Y = SimpleSDMResponse(zeros(Float64, (5, 5)), 0.0, 1.0, 0.0, 1.0)
Y[0.1, 0.1] = 0.2
@test Y[Point(0.1, 0.1)] == 0.2

Z = convert(SimpleSDMPredictor, Y)
Y[0.1, 0.1] = 4.0
@test Z[0.1, 0.1] != Y[0.1, 0.1]
@test Z[0.1, 0.1] == 0.2

Z = convert(SimpleSDMPredictor, Y)
V = values(Z)
@test typeof(V) == Vector{Float64}

# typed similar
c2 = similar(Y, Bool)
@test SimpleSDMLayers._inner_type(c2) == Bool

@test SimpleSDMLayers._inner_type(convert(Int64, c2)) == Int64
@test SimpleSDMLayers._inner_type(convert(Float32, c2)) == Float32

# replacement
s1 = SimpleSDMResponse(collect(reshape(1:9, 3, 3)))
@test length(s1) == 9
replace!(s1, 1 => 2, 3 => 2, 9 => nothing)
@test length(s1) == 8
@test s1.grid[1, 1] == 2
@test s1.grid[3, 1] == 2
@test s1.grid[1, 3] == 7
@test isnothing(s1.grid[3, 3])

s1 = SimpleSDMPredictor(collect(reshape(1:9, 3, 3)))
@test length(s1) == 9
s2 = replace(s1, 1 => 2, 3 => 2, 9 => nothing)
@test length(s2) == 8
@test s2.grid[1, 1] == 2
@test s2.grid[3, 1] == 2
@test s2.grid[1, 3] == 7

# ==, isequal, hash
l1 = SimpleSDMPredictor(rand(180, 90))
l2 = SimpleSDMPredictor(rand(180, 90))
l3 = copy(l1)
l4 = similar(l1)
replace!(l4, nothing => NaN)

@test l1 == l1
@test l1 === l1
@test l2 != l1
@test l3 == l1
@test l3 !== l1

@test l4 != l1
@test l4 == l4
@test !isequal(l4, l1)
@test isequal(l4, l4)

@test hash(l1) == hash(l1)
@test hash(l2) != hash(l1)
@test hash(l3) == hash(l1)
@test hash(l4) != hash(l1)
@test hash(l4) == hash(l4)

# getindex(layer1, layer2)
l1 = SimpleSDMPredictor(rand(20, 20); left = 0.0, right = 20.0, bottom = 0.0, top = 20.0)
l2 =
    SimpleSDMPredictor(rand(40, 40); left = -10.0, right = 30.0, bottom = -10.0, top = 30.0)
@test stride(l1) == stride(l2)

@test_throws ArgumentError clip(l1, l2)
@test stride(clip(l2, l1)) == stride(l1)

# replacement
l1 = SimpleSDMResponse(rand(Bool, 10, 10))
l2 = replace(l1, true => false)
@test all(l2.grid .== false)

# Operations
l1 = SimpleSDMResponse(ones(Int64, 2, 2))
@test sum(2l1) == 2sum(l1)
@test sum(l1 * 2) == 2sum(l1)

end
