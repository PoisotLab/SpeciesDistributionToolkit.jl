"""
This solves the direct (first) geodetic problem assuming Haversine distances are
a correct approximation of the distance between points.
"""
function _random_point(ref, d; R=Fauxcurrences._earth_radius)
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
    point = _random_point(points[:, rand(1:size(points, 2))], rand(distances))
    while isnothing(layer[point...])
        point = _random_point(points[:, rand(1:size(points, 2))], rand(distances))
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
function _bin_distribution(D::Matrix{Float64}, m::Float64)::Vector{Float64}
    bins = 11
    t = prod(size(D))
    r = LinRange(0.0, m + eps(typeof(m)), bins + 1)
    c = zeros(Float64, bins)
    @inbounds for i in 1:bins
        c[i] = count(r[i] .< D .< r[i+1])/t
    end
    return c
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
function _distance_between_binned_distributions(p, q)
    return sqrt(Distances.js_divergence(p, q) / log(2))
end

"""
Generates the internal distance matrices
"""
function preallocate_distance_matrices(obs; samples=size.(obs,2))
    obs_intra = [zeros(Float64, (size(obs[i], 2), size(obs[i], 2))) for i in 1:length(obs)]
    obs_inter = [zeros(Float64, (size(obs[i], 2), size(obs[j], 2))) for i in 1:(length(obs)-1) for j in (i+1):length(obs)]
    sim_intra = [zeros(Float64, (samples[i], samples[i])) for i in 1:length(obs)]
    sim_inter = [zeros(Float64, (samples[i], samples[j])) for i in 1:(length(obs)-1) for j in (i+1):length(obs)]
    return obs_intra, obs_inter, sim_intra, sim_inter
end

function measure_intraspecific_distances!(intra, obs; updated=1:length(obs))
    for i in 1:length(obs)
        if i in updated
            Distances.pairwise!(intra[i], Fauxcurrences._distancefunction, obs[i])
        end
    end
end

function measure_interspecific_distances!(inter, obs; updated=1:length(obs))
    cursor = 1
    for i in 1:(length(obs)-1)
        for j in (i+1):length(obs)
            if (i in updated)|(j in updated)
               Distances.pairwise!(inter[cursor], Fauxcurrences._distancefunction, obs[i], obs[j])
            end
            cursor += 1
        end
    end
end