module SSLTestTiling
using SimpleSDMLayers
using Test

# hcat / vcat
l1 = SimpleSDMPredictor(rand(10, 10); left=0.0, right=10.0, bottom=0.0, top=10.0)
l2 = SimpleSDMPredictor(rand(10, 10); left=0.0, right=10.0, bottom=10.0, top=20.0)
l3 = SimpleSDMPredictor(rand(10, 10); left=10.0, right=20.0, bottom=0.0, top=10.0)
l4 = SimpleSDMPredictor(rand(10, 10); left=10.0, right=20.0, bottom=10.0, top=20.0)

g5 = vcat(hcat(l1.grid, l3.grid), hcat(l2.grid, l4.grid))
l5 = SimpleSDMPredictor(g5; left=0.0, right=20.0, bottom=0.0, top=20.0)

ml1 = hcat(l1, l3)
vl1 = vcat(l1, l2)
ml2 = hcat(l2, l4)
vl2 = vcat(l3, l4)

vml = vcat(ml1, ml2)
mvl = hcat(vl1, vl2)

@test all(vml.grid == mvl.grid)

for l in (vml, mvl)
    @test all(l.grid == l5.grid)
    @test size(l) == size(l5)
    @test stride(l) == stride(l5)
    @test longitudes(l) == longitudes(l5)
    @test latitudes(l) == latitudes(l5)
    @test l.left == l5.left
    @test l.right == l5.right
    @test l.bottom == l5.bottom
    @test l.top == l5.top
end

end
