module SSLTestDataRead
using SimpleSDMLayers
using Test

file = joinpath(dirname(pathof(SimpleSDMLayers)), "data", "connectivity.tiff")
struct MyConnectivityMap <: SimpleSDMLayers.SimpleSDMSource end
SimpleSDMLayers.latitudes(::Type{MyConnectivityMap}) = (-10.0, 10.0)
SimpleSDMLayers.longitudes(::Type{MyConnectivityMap}) = (-20.0, 20.0)
mp = raster(SimpleSDMResponse, MyConnectivityMap(), file)

@test typeof(mp) <: SimpleSDMResponse
@test size(mp) = (1255, 1206)

end
