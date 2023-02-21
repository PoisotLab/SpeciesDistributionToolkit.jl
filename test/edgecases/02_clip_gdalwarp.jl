module TestThatClipIsConsistentWithGDAL

# This test is described in the test for `clip` in SimpleSDMLayers. Properly
# comparing the result of clip with GDAL.jl and gdalwarp requires writing and
# reading a layer, which belongs here in the tests for
# SpeciesDistributionToolkit.

using SpeciesDistributionToolkit
using GDAL
using Test

# Object names are consistent with the SimpleSDMLayers test

M2 = rand(Bool, (1080, 2160))
S2 = SimpleSDMPredictor(M2, -180.0, 180.0, -90.0, 90.0)

F2 = "$(tempname()).tif"
F3 = "$(tempname()).tif"
SpeciesDistributionToolkit.save(F2, convert(Float32, S2));
run(`$(GDAL.gdalwarp_path()) $F2 $F3 -te -180.0 -90.0 180.0 8.0 -overwrite`);
S3 = SpeciesDistributionToolkit._read_geotiff(F3, SimpleSDMPredictor);
cl3 = clip(convert(Float32, S2); top=8.0);

@test cl3 == S3
@test size(cl3) == size(S3)
@test boundingbox(cl3) == boundingbox(S3)

end