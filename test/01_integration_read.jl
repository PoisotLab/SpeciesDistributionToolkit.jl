module TestThatWeCanReadStuff

using SpeciesDistributionToolkit
using Test

# Get some EarthEnv data
layer = SimpleSDMPredictor(RasterData(EarthEnv, LandCover); layer = 1)
D = SimpleSDMLayers._inner_type(layer)

# Write the data
f = tempname()
SpeciesDistributionToolkit._write_geotiff(f, [layer]; driver = "GTiff", nodata = typemax(D))
@test isfile(f)

# Read the data
layer2 = SpeciesDistributionToolkit._read_geotiff(f, SimpleSDMPredictor)
@test typeof(layer2) <: SimpleSDMPredictor
@test all(values(layer) .== values(layer2))

# Write the data
f = tempname()
SpeciesDistributionToolkit.save(f, [layer]; nodata = typemax(D))
@test isfile(f)

# Read the data
layer2 = SpeciesDistributionToolkit.read(f, SimpleSDMPredictor)
@test typeof(layer2) <: SimpleSDMPredictor
@test all(values(layer) .== values(layer2))

end
