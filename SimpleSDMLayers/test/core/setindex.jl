module SSLTestSetIndex
using SimpleSDMLayers
using Test

S = SimpleSDMResponse(zeros(10, 10), 0.0, 1.0, 0.0, 1.0)

# Change a single value
changepoint = Point(0.2, 0.5)
S[changepoint] = 1.0
@test S[changepoint] == 1.0

# Change multiple by multiple values
changepoints = [Point(rand(2)...) for i in 1:8]
changevalues = rand(length(changepoints))
S[changepoints] = changevalues
# NOTE we test that the values in the layer are part of the pool of possible
# values, because it is entirely possible that two points will fall within the
# same cell
@test all(.!isnothing.(indexin(S[changepoints], changevalues)))

# Change multiple by multiple values as a matrix
changepoints = reshape([Point(rand(2)...) for i in 1:8], (2, 4))
changevalues = reshape(rand(length(changepoints)), (2,4))
S[changepoints] = changevalues
@test all(.!isnothing.(indexin(S[changepoints], changevalues)))

# Change multiple values by a single value
changepoints = [Point(rand(2)...) for i in 1:8]
S[changepoints] .= 5.0
@test all(S[changepoints] .== 5.0)

# Change multiple values by a single value as a matrix
changepoints = reshape([Point(rand(2)...) for i in 1:8], (2, 4))
S[changepoints] .= 5.0
@test all(S[changepoints] .== 5.0)

end