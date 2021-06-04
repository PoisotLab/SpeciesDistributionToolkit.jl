module SSLTestDataRead
using SimpleSDMLayers
using Test

l = SimpleSDMPredictor(WorldClim, BioClim, 1)

f1 = tempname()
geotiff(f1, l)
mp1 = geotiff(SimpleSDMResponse, f1)

@test typeof(mp1) <: SimpleSDMResponse
@test size(mp1) == size(l)
@test mp1 == l

f2 = tempname()
geotiff(f2, l; nodata=-3.4f38)
mp2 = geotiff(SimpleSDMPredictor, f2)

@test typeof(mp2) <: SimpleSDMResponse
@test size(mp2) == size(l)
@test mp2 == l

end
