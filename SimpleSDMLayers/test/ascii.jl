module SSLTestASCII
using SimpleSDMLayers
using Test

M = rand(Float64, 4, 8)
M = convert(Matrix{Union{Nothing,Float64}}, M)
M[rand(Bool, size(M))] .= nothing
S = SimpleSDMPredictor(M, 0.0, 2.0, 0.0, 1.0)

ascii(S, "test.asc")
U = ascii("test.asc")

@test isfile("test.asc")
@test all(S.grid .== U.grid)
@test S.left == U.left
@test S.bottom == U.bottom
@test S.right == U.right
@test S.top == U.top
@test s
@test size(S) == size(U)

rm("test.asc")

end