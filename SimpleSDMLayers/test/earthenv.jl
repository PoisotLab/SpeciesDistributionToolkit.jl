module SSLTestLandCover
using SimpleSDMLayers
using Test

lc1 = SimpleSDMPredictor(EarthEnv, LandCover, 1; left=-5.0, right=7.0, bottom=30.0, top=45.0)
@test typeof(lc1) <: SimpleSDMPredictor

he1 = SimpleSDMPredictor(EarthEnv, HabitatHeterogeneity, 1; left=-5.0, right=7.0, bottom=30.0, top=45.0)
@test typeof(he1) <: SimpleSDMPredictor

end
