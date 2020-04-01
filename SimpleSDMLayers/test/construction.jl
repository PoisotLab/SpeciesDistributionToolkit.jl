module SSLTestConstruction
using SimpleSDMLayers
using Test

# Correct type
M = rand(Bool, (5,5))
S = SimpleSDMPredictor(M, 0.0, 1.0, 0.0, 1.0)
@test typeof(S) == SimpleSDMPredictor{Bool}

# Correct type
M = rand(Bool, (5,5))
R = SimpleSDMResponse(M, 0.0, 1.0, 0.0, 1.0)
@test typeof(R) == SimpleSDMResponse{Bool}

# Construction only from a matrix
R = SimpleSDMResponse(M)
@test typeof(R) == SimpleSDMResponse{Bool}
@test R.left = -180.
@test R.right = -180.
@test R.top = 90.
@test R.bottom = -90.

R = SimpleSDMPredictor(M)
@test typeof(R) == SimpleSDMPredictor{Bool}
@test R.left = -180.
@test R.right = -180.
@test R.top = 90.
@test R.bottom = -90.

end
