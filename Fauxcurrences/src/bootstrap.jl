"""
Generates the initial proposition for points - this function generates the
points for all taxa at once, so some knowledge of the distance matrices is
required. Note that this function is modifying the *bootstrap* object, in order
to make be as efficient as possible.
"""
function _bootstrap!(sim, layer, obs, obs_d_intra, obs_d_inter, obs_d_)
    all_points = copy(points)
    all_points[:, 1] .= new_random_point(layer, points, Dxy)
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