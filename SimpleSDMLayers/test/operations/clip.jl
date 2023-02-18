module SSLTestClip
using SimpleSDMLayers
using Test

M = rand(Bool, (10, 10))
S = SimpleSDMPredictor(M, 0.0, 1.0, 0.0, 1.0)

cl1 = clip(S; left = 0.2, right = 0.6, bottom = 0.5, top = 1.0)
@test typeof(cl1) == typeof(S)
@test cl1.top ≈ 1.0
@test cl1.bottom ≈ 0.5
@test cl1.right ≈ 0.6
@test cl1.left ≈ 0.2
@test clip(S; left = 0.19).left <= 0.2

cl2 = clip(S; left = 0.2, bottom = 0.5)
@test typeof(cl2) == typeof(S)
@test cl2.top ≈ 1.0
@test cl2.bottom ≈ 0.5
@test cl2.right ≈ 1.0
@test cl2.left ≈ 0.2

# Test the expand keyword to include points that fall on the limit between two cells
M2 = rand(Bool, (1080, 2160))
S2 = SimpleSDMPredictor(M2, -180.0, 180.0, -90.0, 90.0)

# Test that expand works, including at the edges of the layer
@test clip(S2; left = 0.0).left == 0.0
@test clip(S2; left = 0.0, expand = [:left]).left < 0.0
@test clip(S2; left = -180.0).left == -180.0
@test clip(S2; left = -180.0, expand = [:left]).left == -180.0

end