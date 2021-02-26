module SSLTestMosaic
using SimpleSDMLayers
using Test
using Statistics

n1 = fill(1.0f0, 5, 5)
s1 = SimpleSDMResponse(n1, 0., 2., 0., 2.)

n2 = fill(2.0, 5, 5)
s2 = SimpleSDMResponse(n2, 1., 3., 1., 3.)

n3 = fill(3.0, 10, 10)
s3 = SimpleSDMResponse(n3, -1.8, 2.2, 1.4, 5.4)

n4 = fill(4.0, 5, 3)
s4 = SimpleSDMResponse(n4, 3.0, 4.2, 3.0, 5.0)

# Test
L = mosaic(mean, [s1, s2, s3, s4])

@test typeof(L) == SimpleSDMResponse{Float32}
@test extrema(L) == (1.0f0, 4.0f0)

end


