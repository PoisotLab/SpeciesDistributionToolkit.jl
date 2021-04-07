module SSLTestCHELSA
using SimpleSDMLayers
using Test

lc1 = SimpleSDMPredictor(CHELSA, BioClim, 1; left=-5.0, right=7.0, bottom=30.0, top=45.0)
@test typeof(lc1) <: SimpleSDMPredictor

lc1 = SimpleSDMPredictor(CHELSA, BioClim, 1:2; left=-5.0, right=7.0, bottom=30.0, top=45.0)
@test eltype(lc1) <: SimpleSDMPredictor

lc1 = SimpleSDMPredictor(CHELSA, BioClim, [1,2,3]; left=-5.0, right=7.0, bottom=30.0, top=45.0)
@test eltype(lc1) <: SimpleSDMPredictor

lc1 = SimpleSDMPredictor(CHELSA, BioClim, CanESM2, RCP26, 1; left=-5.0, right=7.0, bottom=30.0, top=45.0)
@test typeof(lc1) <: SimpleSDMPredictor

lc1 = SimpleSDMPredictor(CHELSA, BioClim, CanESM2, RCP26, 1:2; left=-5.0, right=7.0, bottom=30.0, top=45.0)
@test eltype(lc1) <: SimpleSDMPredictor

lc1 = SimpleSDMPredictor(CHELSA, BioClim, CanESM2, RCP26, [1,2,3]; left=-5.0, right=7.0, bottom=30.0, top=45.0)
@test eltype(lc1) <: SimpleSDMPredictor


end
