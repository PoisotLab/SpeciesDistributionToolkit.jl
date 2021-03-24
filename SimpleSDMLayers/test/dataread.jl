module SSLTestDataRead
using SimpleSDMLayers
using Test

file = joinpath(dirname(pathof(SimpleSDMLayers)), "..", "data", "connectivity.tiff")
mp = geotiff(SimpleSDMResponse, file)

@test typeof(mp) <: SimpleSDMResponse
@test size(mp) == (1255, 1206)

end
