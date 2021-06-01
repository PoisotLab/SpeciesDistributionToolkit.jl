module SSLTestSubsetting
using SimpleSDMLayers
using Test

temp = SimpleSDMPredictor(WorldClim, BioClim, 1)
@test size(temp) == (1080, 2160)

coords = (left = -145.0, right = -50.0, bottom = 20.0, top = 75.0)
layer = temp[coords]
@test size(layer) == (330, 570)

@test layer.left == coords.left
@test layer.right == coords.right
@test layer.bottom == coords.bottom
@test layer.top == coords.top

@test stride(layer) == stride(temp)
@test longitudes(layer)[1] == -144.91666666666666
@test longitudes(layer)[end] == -50.083333333333336
@test latitudes(layer)[1] == 20.083333333333332
@test latitudes(layer)[end] == 74.91666666666667

end