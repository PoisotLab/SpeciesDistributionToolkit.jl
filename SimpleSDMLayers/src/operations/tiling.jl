"""
    tile!(tiles::Matrix{T}, layer::T, s::Tuple{Integer, Integer} = (5, 5)) where {T <: SimpleSDMLayer}

Split a layer into a matrix of tiles (with size `s`), where the tiles are as
evenly sized as possible, and have strictly matching boundaries.
"""
function tile!(
    tiles::Matrix{T},
    layer::T,
    s::Tuple{Integer, Integer} = (5, 5),
) where {T <: SimpleSDMLayer}
    @assert s[1] < size(layer, 1)
    @assert s[2] < size(layer, 2)
    @assert size(tiles) == s
    # Return type
    RT = T <: SimpleSDMPredictor ? SimpleSDMPredictor : SimpleSDMResponse
    # Boundaries from the bounding box
    l = layer.left
    r = layer.right
    b = layer.bottom
    t = layer.top
    l_r_points = LinRange(l, r, s[2] + 1)
    t_b_points = LinRange(t, b, s[1] + 1)
    # Split the coordinates
    dim_1_cutoff = floor.(Int, LinRange(1, size(layer, 1)+1, s[1] + 1))
    dim_2_cutoff = floor.(Int, LinRange(1, size(layer, 2)+1, s[2] + 1))
    # Add the layers to the tiles matrix
    for i in eachindex(dim_1_cutoff)[2:end]
        start1, stop1 = dim_1_cutoff[(i - 1):i]
        for j in eachindex(dim_2_cutoff)[2:end]
            start2, stop2 = dim_2_cutoff[(j - 1):j]
            tiles[(i - 1), (j - 1)] =
                RT(
                    layer.grid[start1:(stop1-1), start2:(stop2-1)],
                    l_r_points[j - 1],
                    l_r_points[j],
                    t_b_points[i],
                    t_b_points[i - 1],
                )
        end
    end
    return tiles
end

"""
    tile(layer::T, s::Tuple{Integer, Integer} = (5, 5)) where {T <: SimpleSDMLayer}

Split a layer into a matrix of tiles (with size `s`), where the tiles are as
evenly sized as possible, and have strictly matching boundaries. This function
will allocate the return matrix.
"""
function tile(layer::T, s::Tuple{Integer, Integer} = (5, 5)) where {T <: SimpleSDMLayer}
    # Create the tiles
    tiles = Matrix{T}(undef, s...)
    tile!(tiles, layer, s)
    return tiles
end

"""
    stitch(tiles::Matrix{T})

Returns a layer from a series of layer tiles, as produced by `tile` or `tile!`.
"""
function stitch(tiles::Matrix{T}) where {T <: SimpleSDMLayer}
    for i in axes(tiles, 1)[1:(end - 1)]
        for j in axes(tiles, 2)[1:(end - 1)]
            @assert tiles[i, j].left == tiles[(i + 1), j].left
            @assert tiles[i, j].right == tiles[(i + 1), j].right
            @assert tiles[i, j].bottom == tiles[(i + 1), j].top
            @assert tiles[i, j].bottom == tiles[i, (j + 1)].bottom
            @assert tiles[i, j].top == tiles[i, (j + 1)].top
            @assert tiles[i, j].right == tiles[i, (j + 1)].left
        end
    end
    # Bounding box of the tile
    left = minimum([t.left for t in tiles])
    right = maximum([t.left for t in tiles])
    bottom = minimum([t.bottom for t in tiles])
    top = maximum([t.top for t in tiles])
    # Size of the raster
    rows = size.(tiles[:,1], 1)
    cols = size.(tiles[1,:], 2)
    # Create a grid to store info of the correct type
    RT = eltype(tiles) <: SimpleSDMPredictor ? SimpleSDMPredictor : SimpleSDMResponse
    IT = SimpleSDMLayers._inner_type(tiles[1])
    grid = convert(Matrix{Union{Nothing,IT}}, fill(nothing, sum(rows), sum(cols)))
    # Fill
    for i in axes(tiles, 1)
        for j in axes(tiles, 2)
            start_i = i == 1 ? 1 : sum(rows[1:(i-1)]) + 1
            start_j = j == 1 ? 1 : sum(cols[1:(j-1)]) + 1
            stop_i = sum(rows[1:i])
            stop_j = sum(cols[1:j])
            grid[start_i:stop_i,start_j:stop_j] .= tiles[i,j].grid
        end
    end
    # Return
    return RT(grid, left, right, bottom, top)
end
