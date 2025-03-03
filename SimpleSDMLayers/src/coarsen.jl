"""
    coarsen(f, L::SDMLayer, mask=(2, 2))

Coarsens a layer by collecting a sub-grid of size `mask`, and applying the
function `f` to all non-empty cells within this mask. The core constraint is
that `f` must take a vector and return a single element (and the size of the
mask must be compatible with the size of the layer).
"""
function coarsen(f, L::SDMLayer, mask=(2, 2))
    @assert iszero(size(L, 1) % mask[1])
    @assert iszero(size(L, 2) % mask[2])
    new_size = Int.(size(L) .// mask)
    # Get return type
    test_return = f(values(L)[1:prod(mask)])
    @assert length(test_return) == 1
    T = typeof(test_return)
    # New layer
    C = SDMLayer(zeros(T, new_size); x=L.x, y=L.y, crs=L.crs)
    # Iterate
    for i in axes(C, 1)
        i_range = (i-1)*mask[1].+(1:mask[1])
        for j in axes(C, 2)
            j_range = (j-1)*mask[2].+(1:mask[2])
            # Are there cells in here?
            visible_cells = L.indices[i_range, j_range]
            if !any(visible_cells)
                # We hide the cells if they are ALL missing
                C.indices[i,j] = false
            else
                # Otherwise we calculate
                grid_values = L.grid[i_range, j_range][findall(visible_cells)]
                C.grid[i,j] = f(grid_values)
            end
        end
    end
    return C
end

@testitem "We can coarsen a layer" begin
    using NeutralLandscapes
    L = SDMLayer(DiamondSquare(), (10, 20))
    C = coarsen(sum, L, (2, 2))
    @test size(C) == (5, 10)
    @test C.grid[1, 1] == sum(L.grid[1:2, 1:2])
    @test C.x == L.x
    @test C.y == L.y
    @test C.crs == L.crs
end

@testitem "We can coarsen a layer with missing data" begin
    using NeutralLandscapes
    L = SDMLayer(DiamondSquare(), (20, 50))
    nodata!(L, x -> 0.2 <= x <= 0.6)
    C = coarsen(sum, L, (2, 2))
    @test size(C) == (10, 25)
    @test sum(L.indices) < prod(size(L.indices))
end

@testitem "We cannot coarsen a layer with a wrong sized mask" begin
    using NeutralLandscapes
    L = SDMLayer(DiamondSquare(), (20, 50))
    @test_throws AssertionError coarsen(sum, L, (3, 19))
end