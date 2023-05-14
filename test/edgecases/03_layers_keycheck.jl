module TestThatWrongKeywordsAreCaught

using SpeciesDistributionToolkit
using Test

provider = RasterData(WorldClim2, BioClim)
@test_throws "The keyword argument layers is not" SimpleSDMPredictor(provider; layers=3)

end
