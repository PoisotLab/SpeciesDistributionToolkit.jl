module SSLTestConstruction
using SimpleSDMLayers
using Test

# Correct type
M = rand(Bool, (5,5))
S = SimpleSDMPredictor(M, 0.0, 1.0, 0.0, 1.0)
@test typeof(S) == SimpleSDMPredictor{Bool, Float64}

# Correct type
M = rand(Bool, (5,5))
R = SimpleSDMResponse(M, 0.0, 1.0, 0.0, 1.0)
@test typeof(R) == SimpleSDMResponse{Bool, Float64}

end
