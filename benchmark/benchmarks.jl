using BenchmarkTools
using NeutralLandscapes
using SpeciesDistributionToolkit
import Random
Random.seed!(123451234123121)

const SUITE = BenchmarkGroup()

# SimpleSDMLayers benchmark
SUITE["SimpleSDMLayers"] = BenchmarkGroup()

L = SDMLayer(DiamondSquare(), (100, 100))
M = [SDMLayer(DiamondSquare(), (100, 100)) for _ in 1:10]

SUITE["SimpleSDMLayers"]["nodata"] = @benchmarkable nodata!($L, $(rand(values(L))))
SUITE["SimpleSDMLayers"]["mosaic"] = @benchmarkable mosaic(sum, $M)
SUITE["SimpleSDMLayers"]["rescale"] = @benchmarkable rescale($L, 0., 1.)
SUITE["SimpleSDMLayers"]["quantize"] = @benchmarkable quantize($L, 10)

# SDeMo benchmark
SUITE["SDeMo"] = BenchmarkGroup()

X, y = SDeMo.__demodata()

SUITE["SDeMo"]["splits"]["kfold"] = @benchmarkable kfold(sdm) setup=(SDM(RawData, NaiveBayes, X, y))
SUITE["SDeMo"]["splits"]["LOO"] = @benchmarkable leaveoneout(sdm) setup=(SDM(RawData, NaiveBayes, X, y))
SUITE["SDeMo"]["splits"]["montecarlo"] = @benchmarkable montecarlo(sdm) setup=(SDM(RawData, NaiveBayes, X, y))

SUITE["SDeMo"]["crossvalidate"]["rawdata - decisiontree"] = @benchmarkable crossvalidate(sdm, kfold(sdm)) setup=(SDM(RawData, DecisionTree, X, y))
SUITE["SDeMo"]["crossvalidate"]["pca - decisiontree"] = @benchmarkable crossvalidate(sdm, kfold(sdm)) setup=(SDM(PCATransform, DecisionTree, X, y))

SUITE["SDeMo"]["train"]["random forest"] = @benchmarkable train!(sdm) setup=(Bagging(SDM(ZScore, DecisionTree, X, y), 20))
SUITE["SDeMo"]["train"]["rotation forest"] = @benchmarkable train!(sdm) setup=(Bagging(SDM(PCATransform, DecisionTree, X, y), 20))
