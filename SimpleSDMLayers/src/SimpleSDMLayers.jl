module SimpleSDMLayers

using ArchGDAL
using HTTP
using RecipesBase
using ZipFile
using Requires

include(joinpath("lib", "types.jl"))
export SimpleSDMLayer, SimpleSDMResponse, SimpleSDMPredictor

include(joinpath("lib", "overloads.jl"))

include(joinpath("lib", "generated.jl"))

include(joinpath("lib", "basics.jl"))
export latitudes, longitudes

include(joinpath("lib", "iteration.jl"))

include(joinpath("datasets", "sources.jl"))
include(joinpath("datasets", "download_layer.jl"))
export EarthEnv, WorldClim, BioClim

include(joinpath("datasets", "geotiff.jl"))
include(joinpath("datasets", "raster.jl"))
include(joinpath("datasets", "worldclim.jl"))
include(joinpath("datasets", "chelsa.jl"))
include(joinpath("datasets", "landcover.jl"))
export worldclim
export bioclim
export landcover

include(joinpath("operations", "coarsen.jl"))
include(joinpath("operations", "sliding.jl"))
include(joinpath("operations", "mask.jl"))
export coarsen, slidingwindow, mask

include(joinpath("recipes", "recipes.jl"))

# This next bit is about being able to change the path for raster assets
# globally, which avoids duplication this argument across multiple functions.
_layers_assets_path = "assets"
function assets_path()
    isdir(SimpleSDMLayers._layers_assets_path) || mkdir(SimpleSDMLayers._layers_assets_path)
    return SimpleSDMLayers._layers_assets_path
end

# Fixes the export of clip when GBIF or others are loaded
clip(::T) where {T <: SimpleSDMLayer} = nothing
export clip

function __init__()
    @require GBIF="ee291a33-5a6c-5552-a3c8-0f29a1181037" begin
        @info "GBIF integration loaded"
        include(joinpath(dirname(pathof(SimpleSDMLayers)), "integrations", "GBIF.jl"))
    end
    @require DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0" begin
        @info "DataFrames integration loaded"
        include(joinpath(dirname(pathof(SimpleSDMLayers)), "integrations", "DataFrames.jl"))
    end

end

end # module
