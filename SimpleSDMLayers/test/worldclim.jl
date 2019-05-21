module SLLTestWorldclim
using SimpleSDMLayers
using Test

wc1and2 = worldclim([1,2])

@test typeof(first(wc1and2)) <: SimpleSDMPredictor

wc3 = worldclim(3)
@test typeof(wc3) <: SimpleSDMPredictor

end
