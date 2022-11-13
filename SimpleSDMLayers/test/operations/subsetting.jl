module SSLTestSubsetting
using SimpleSDMLayers
using Test

temp = SimpleSDMPredictor(rand(1080, 2160))
@test size(temp) == (1080, 2160)

coords = (left=-145.0, right=-50.0, bottom=20.0, top=75.0)
l1 = clip(temp; coords...)

@test l1.left == coords.left
@test l1.right == coords.right
@test l1.bottom == coords.bottom
@test l1.top == coords.top

@test stride(l1) == stride(temp)
@test longitudes(l1)[1] ≈ coords.left atol = 0.1
@test longitudes(l1)[end] ≈ coords.right atol = 0.1
@test latitudes(l1)[1] ≈ coords.bottom atol = 0.1
@test latitudes(l1)[end] ≈ coords.top atol = 0.1

end
