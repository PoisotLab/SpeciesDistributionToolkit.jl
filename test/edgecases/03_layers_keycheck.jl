module TestThatWrongKeywordsAreCaught

using SpeciesDistributionToolkit
using Test

provider = RasterData(WorldClim2, BioClim)
SimpleSDMPredictor(provider; layers=3)

end
