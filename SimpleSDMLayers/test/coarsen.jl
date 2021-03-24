module SSLTestCoarsen
using SimpleSDMLayers
using Test
using Statistics

M = convert(Matrix, reshape(1:36, (6,6)))
S = SimpleSDMPredictor(M, 0.0, 1.0, 0.0, 1.0)

min22 = coarsen(S, minimum, (2,2))
@test min22.grid == [1 13 25; 3 15 27; 5 17 29]

max33 = coarsen(S, maximum, (3,3))
@test max33.grid == [15 33; 18 36]

# Coarsen should play nicely with the non-float types
M = SimpleSDMResponse(["a" nothing "b" "c"; "d" "e" "f" "g"; "d" "e" nothing "g"; nothing "x" "y" "z"], 0.0, 1.0, 0.0, 1.0)
@test coarsen(M, x -> reduce(*, x), (2,2)).grid == ["ade" "bfcg"; "dex" "ygz"]

# Should work on a real-world example for a series of functions
temperature = SimpleSDMResponse(WorldClim, BioClim, 1)
for f in [minimum, maximum, mean, median]
    t_coarse = coarsen(temperature, f, (10, 10))
    @test typeof(t_coarse) <: SimpleSDMPredictor
end

end
