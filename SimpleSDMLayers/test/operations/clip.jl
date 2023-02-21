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

# Test clipping with natural coordinates exactly on the limit
exact_lats = (S2.bottom+1.0):1.0:(S2.top-1.0)
exact_lons = (S2.left+1.0):1.0:(S2.right-1.0)
@test all([isequal(l, clip(S2; top=l).top) for l in exact_lats])
@test all([isequal(l, clip(S2; bottom=l).bottom) for l in exact_lats])
@test all([isequal(l, clip(S2; left=l).left) for l in exact_lons])
@test all([isequal(l, clip(S2; right=l).right) for l in exact_lons])

# Test clipping with non-natural coordinates
@test all([isequal(l, clip(S; top=l).top) for l in 0.1:0.1:0.9])
@test all([isequal(l, clip(S; bottom=l).bottom) for l in 0.1:0.1:0.9])
@test all([isequal(l, clip(S; left=l).left) for l in 0.1:0.1:0.9])
@test all([isequal(l, clip(S; right=l).right) for l in 0.1:0.1:0.9])

# Test that clip is consistent with GDAL.jl
# This test requires to read and write the data, which is handled by
# SpeciesDistributionToolkit, not SimpleSDMLayers. We'll leave the code
# commented out here and test only with the values that should be returned when
# using GDAL.
#=
using SpeciesDistributionToolkit
using GDAL
F2 = "$(tempname()).tif"
F3 = "$(tempname()).tif"
SpeciesDistributionToolkit.save(F2, convert(Float32, S2));
run(`$(GDAL.gdalwarp_path()) $F2 $F3 -te -180.0 -90.0 180.0 8.0 -overwrite`)
S3 = SpeciesDistributionToolkit._read_geotiff(F3, SimpleSDMPredictor);
cl3 = clip(convert(Float32, S2); top=8.0);
@test cl3 == S3
@test size(cl3) == size(S3)
@test boundingbox(cl3) == boundingbox(S3)
=#

cl3 = clip(convert(Float32, S2); top=8.0);
@test size(cl3) == (588, 2160)
@test boundingbox(cl3) == (left = -180.0, right = 180.0, bottom = -90.0, top = 8.0)

end