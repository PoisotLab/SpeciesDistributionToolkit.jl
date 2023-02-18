module TestThatStitchIsNotInAMood

# The stitching sometimes gave the wrong bounding box after using `map`, so this
# checks this doesn't happen anymore

using SpeciesDistributionToolkit
using Test

# Get some data
dataprovider = RasterData(EarthEnv, LandCover)
spatial_extent = (left = -80.00, bottom = 43.19, right = -70.94, top = 46.93)
trees = sum([
    SimpleSDMPredictor(dataprovider; layer = i, full = true, spatial_extent...) for
    i in 1:4
])

for tilesize in [(3, 4), (8, 8), (4, 3), (9, 5), (2, 2), (12, 1), (3, 6)]

    # make the tiles
    tiles = tile(trees, tilesize)
    @test eltype(tiles) == typeof(trees)

    # stitch the tiles as they are
    tiled_trees = stitch(tiles)
    @test typeof(tiled_trees) == typeof(trees)
    @test size(tiled_trees) == size(trees)
    @test tiled_trees.grid == trees.grid
    @test tiled_trees.left == trees.left
    @test tiled_trees.right == trees.right
    @test tiled_trees.bottom == trees.bottom
    @test tiled_trees.top == trees.top

    # stitch the tiles after a transform
    more_trees  = stitch(map(x -> 2x, tiles))
    @test size(more_trees) == size(trees)
    @test more_trees.left == trees.left
    @test more_trees.right == trees.right
    @test more_trees.bottom == trees.bottom
    @test more_trees.top == trees.top

end

end