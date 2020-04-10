module SSLTestLandCover
using SimpleSDMLayers
using Test

lc1and2 = landcover([1,2])

@test typeof(first(lc1and2)) <: SimpleSDMPredictor

lc3 = landcover(3)
@test typeof(lc3) <: SimpleSDMPredictor

lcrange = landcover(1:5)
@test eltype(lcrange) <: SimpleSDMPredictor

end
