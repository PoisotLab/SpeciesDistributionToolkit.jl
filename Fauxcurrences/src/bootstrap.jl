"""
Generates the initial proposition for points

TODO: switch between using empirical points and simulated points, the later
generates worse initial solutions
"""
function _bootstrap(layer, points, distances_inter, distances_intra)
    all_points = copy(xy)
    all_points[:, 1] .= new_random_point(layer, xy, Dxy)
    for i in 2:size(xy, 2)
        global point
        invalid = true
        while invalid
            point = new_random_point(layer, xy, Dxy)
            all_points[:, i] .= point
            invalid = maximum(pairwise(Df, all_points[:, 1:i])) > maximum(Dxy)
        end
    end
    return all_points
end