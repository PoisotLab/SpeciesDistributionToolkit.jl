using BenchmarkTools
using SpeciesDistributionToolkit

const SUITE = BenchmarkGroup()

# Construction of name finders

SUITE["SimpleSDMLayers"] = BenchmarkGroup()

L = SimpleSDMLayers.__demodata()
M = [copy(L) for _ in 1:10]

SUITE["SimpleSDMLayers"]["nodata"] = @benchmarkable nodata!(L, $(rand(values(L))))
SUITE["SimpleSDMLayers"]["mosaic"] = @benchmarkable mosaic(sum, $M)
SUITE["SimpleSDMLayers"]["rescale"] = @benchmarkable rescale(L, 0., 1.)
SUITE["SimpleSDMLayers"]["rescale"] = @benchmarkable quantize(L, 10)