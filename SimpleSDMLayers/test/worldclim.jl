module SSLTestWorldclim
using SimpleSDMLayers
using Test

wc1and2 = SimpleSDMPredictor(WorldClim, BioClim, [1,2])
@test typeof(first(wc1and2)) <: SimpleSDMPredictor

temp = SimpleSDMPredictor(WorldClim, BioClim, 1)
@test size(temp) == (1080, 2160)
@test round(first(stride(temp)); digits=2) ≈ round(last(stride(temp)); digits=2)
@test length(longitudes(temp)) == 2160
@test length(latitudes(temp)) == 1080

wc3 = SimpleSDMPredictor(WorldClim, BioClim, 3)
@test typeof(wc3) <: SimpleSDMPredictor

wcrange = SimpleSDMPredictor(WorldClim, BioClim, 1:5)
@test eltype(wcrange) <: SimpleSDMPredictor

end
