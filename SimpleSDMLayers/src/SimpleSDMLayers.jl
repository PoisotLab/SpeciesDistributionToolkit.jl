module SimpleSDMLayers

using GDAL
using HTTP
using RecipesBase
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
export worldclim

#include(joinpath("bioclimaticdata", "chelsa.jl"))
#export bioclim

include(joinpath("operations", "coarsen.jl"))
export coarsen

include(joinpath("recipes", "recipes.jl"))

end # module
