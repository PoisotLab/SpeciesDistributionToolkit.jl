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
@test all(S[changepoints] .== changevalues)

# Change multiple by a single value
changepoints = [Point(rand(2)...) for i in 1:8]
S[changepoints] .= 5.0
@test all(S[changepoints] .== 5.0)

end