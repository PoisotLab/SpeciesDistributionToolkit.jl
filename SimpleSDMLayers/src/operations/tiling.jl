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
    dim_1_cutoff = floor.(Int, LinRange(1, size(layer, 1), s[1] + 1))
    dim_2_cutoff = floor.(Int, LinRange(1, size(layer, 2), s[2] + 1))
    # Add the layers to the tiles matrix
    for i in eachindex(dim_1_cutoff)[2:end]
        start1, stop1 = dim_1_cutoff[(i - 1):i]
        for j in eachindex(dim_2_cutoff)[2:end]
            start2, stop2 = dim_2_cutoff[(j - 1):j]
            tiles[(i - 1), (j - 1)] =
                RT(
                    layer.grid[start1:stop1, start2:stop2],
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