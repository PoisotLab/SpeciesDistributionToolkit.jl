module SSLTestSubsetting
using SimpleSDMLayers
using Test

temp = SimpleSDMPredictor(WorldClim, BioClim, 1)
@test size(temp) == (1080, 2160)

coords = (left = -145.0, right = -50.0, bottom = 20.0, top = 75.0)
l1 = clip(temp; coords...)
l2 = SimpleSDMPredictor(WorldClim, BioClim, 1; coords...)
tempfile = tempname()
geotiff(tempfile, l2)
l3 = geotiff(SimpleSDMPredictor, tempfile)

@test size(l1) == size(l2)
@test size(l1) == size(l3)
@test l1.grid == l2.grid
@test l1.grid == l3.grid

for l in (l1, l2, l3)
    @test size(l) == (330, 570)

    @test l.left == coords.left
    @test l.right == coords.right
    @test l.bottom == coords.bottom
    @test l.top == coords.top

    @test stride(l) == stride(temp)
    @test longitudes(l)[1] == -144.91666666666666
    @test longitudes(l)[end] == -50.083333333333336
    @test latitudes(l)[1] == 20.083333333333332
    @test latitudes(l)[end] == 74.91666666666667
end

end