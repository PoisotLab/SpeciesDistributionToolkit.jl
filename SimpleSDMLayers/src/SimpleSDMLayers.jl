module SimpleSDMLayers

using GDAL
using ZipFile

greet() = print("SimpleSDMLayers is currently UNSTABLE")


include(joinpath("lib", "types.jl"))
export SimpleSDMLayer, SimpleSDMResponse, SimpleSDMPredictor

include(joinpath("lib", "overloads.jl"))

include(joinpath("lib", "basics.jl"))
export latitudes, longitudes

include(joinpath("lib", "geotiff.jl"))
export geotiff


include(joinpath("bioclimaticdata", "worldclim.jl"))

end # module
