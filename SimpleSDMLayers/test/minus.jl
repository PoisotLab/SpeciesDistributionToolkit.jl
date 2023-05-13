module SSLTestMinus

using Test
using SimpleSDMLayers

# Quantitative matrices
refmat = Matrix(reshape(1:9, 3, 3))
SR = SimpleSDMResponse(refmat)
NSR = -SR
@test SimpleSDMLayers.grid(NSR) == -refmat
@test NSR.left == SR.left
@test NSR.right == SR.right
@test NSR.top == SR.top
@test NSR.bottom == SR.bottom

# Negation of binary matrix
refmat = Matrix(reshape(repeat([true, false, true], 3), 3, 3))
SR = SimpleSDMResponse(refmat)
NSR = !SR
@test SimpleSDMLayers.grid(NSR) == (!).(refmat)
@test NSR.left == SR.left
@test NSR.right == SR.right
@test NSR.top == SR.top
@test NSR.bottom == SR.bottom

end
