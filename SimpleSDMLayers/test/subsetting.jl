module SSLTestSubsetting
using SimpleSDMLayers
using Test

temp = SimpleSDMPredictor(WorldClim, BioClim, 1)
@test size(temp) == (1080, 2160)

coords = (left = -145.0, right = -50.0, bottom = 20.0, top = 75.0)
layer = temp[coords]
@test size(layer) == (330, 570)

end