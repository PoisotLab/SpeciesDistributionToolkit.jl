module SSLTestExtrema
using SimpleSDMLayers
using Test

S = SimpleSDMPredictor([1 2 3; 4 5 6; 7 nothing 9], 0.0, 1.0, 0.0, 1.0)

@test extrema(S) == (1, 9)
@test first(findmin(S)) == first(extrema(S))
@test first(findmax(S)) == last(extrema(S))
@test maximum(S) == last(extrema(S))
@test minimum(S) == first(extrema(S))

end
