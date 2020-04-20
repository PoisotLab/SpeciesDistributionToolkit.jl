module SSLTestLandCover
using SimpleSDMLayers
using Test

lc1and2 = landcover([1,2])

@test typeof(first(lc1and2)) <: SimpleSDMPredictor

lc1 = landcover(1)
@test typeof(lc1) <: SimpleSDMPredictor

@info eltype(lc1)

lcrange = landcover(1:2)
@test eltype(lcrange) <: SimpleSDMPredictor

end
