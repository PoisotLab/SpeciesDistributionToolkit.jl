module SSLTestCoarsen
using SimpleSDMLayers
using Test

M = convert(Matrix, reshape(1:36, (6,6)))
S = SimpleSDMPredictor(M, 0.0, 1.0, 0.0, 1.0)

min22 = coarsen(S, minimum, (2,2))
@test min22.grid == [1 13 25; 3 15 27; 5 17 29]

max33 = coarsen(S, maximum, (3,3))
@test max33.grid == [15 33; 18 36]

end
