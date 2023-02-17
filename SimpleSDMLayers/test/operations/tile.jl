module SSLTestTile
using SimpleSDMLayers
using Test

M = rand(Bool, (13, 19))
S = SimpleSDMPredictor(M, -2rand(), 10rand(), -3rand(), 4rand())

tiles = tile(S)
@test eltype(tiles) == typeof(S)
@test tiles[1, 1].left == S.left
@test tiles[1, 1].top == S.top
@test tiles[end, 1].bottom == S.bottom
@test tiles[end, 1].left == S.left
@test tiles[1, end].top == S.top
@test tiles[1, end].right == S.right
@test tiles[end, end].bottom == S.bottom
@test tiles[end, end].right == S.right

@test tiles[1, 1].right == tiles[1, 2].left
@test tiles[1, 1].bottom == tiles[2, 1].top
@test tiles[1, 1].left == tiles[2, 1].left
@test tiles[1, 1].right == tiles[2, 1].right

end