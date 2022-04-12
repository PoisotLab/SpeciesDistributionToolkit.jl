"""
This solves the direct (first) geodetic problem assuming Haversine distances are
a correct approximation of the distance between points.
"""
function _random_point(ref, d; R=Fauxccurences._earth_radius)
    # Convert the coordinates from degrees to radians
    λ, φ = deg2rad.(ref)
    # Get the angular distance
    δ = d / R
    # Pick a random bearing (angle w.r.t. true North)
    α = deg2rad(rand() * 360.0)
    # Get the new latitude
    φ2 = asin(sin(φ) * cos(δ) + cos(φ) * sin(δ) * cos(α))
    # Get the new longitude
    λ2 = λ + atan(sin(α) * sin(δ) * cos(φ), cos(δ) - sin(φ) * sin(φ2))
    # Return the coordinates in degree
    return rad2deg.((λ2, φ2))
end

"""
layer - for ref
xy - points
Dxy - distances
"""
function _generate_new_random_point(layer, points, distances)
    point = _random_point(xy[:, rand(1:size(points, 2))], rand(distances))
    while isnothing(layer[point...])
        point = _random_point(xy[:, rand(1:size(points, 2))], rand(distances))
    end
    return point
end


"""
Bin a distance matrix, using a default count of 20 bins. This function is
instrumental in the package, as it is used internally to calculate the
divergence between the observed and simulated distances distributions. This
specific implementation had the least-worst performance during a series of
benchmarks, but in practice the package is going to spend a lot of time running
it. It is a prime candidate for optimisation.
"""
function _bin_distances(D::Matrix{Float64}, m::Float64)::Vector{Float64}
    bins = 20
    r = LinRange(0.0, m + eps(typeof(m)), bins + 1)
    c = zeros(eltype(D), bins)
    for i in 1:bins
        c[i] = count(D .< r[i+1])
        if i > 1
            c[i] = c[i] - sum(c[1:(i-1)])
        end
    end
    return c ./ sum(c)
end

"""
Returns the Jensen-Shannon distance (i.e. the square root of the divergence) for
the two distance matrices. This version is prefered to the KL divergence in the
original implementation as it prevents the `Inf` values when p(x)=0 and q(x)>0.
The JS divergences is bounded between 0 and the natural log of 2, which gives an
absolute measure of fit allowing to compare the solutions. Note that the value
returned is *already* corrected, so it can be at most 1.0, and at best
(identical matrices) 0.
"""
function _distance_between_distributions(x, y)
    m = max(maximum(x), maximum(y))
    p = _bin_distances(x, m)
    q = _bin_distances(y, m)
    return sqrt(Distances.js_divergence(p, q) / log(2))
end
