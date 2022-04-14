"""
Generates the initial proposition for points - this function generates the
points for all taxa at once, so some knowledge of the distance matrices is
required. Note that this function is modifying the *bootstraped* object, in
order to make be as efficient as possible.

Specifically, the first point for each taxa is picked to respect the maximal
inter-specific distances, and then the following points are picked to respect
the intra and inter-specific distances. Points after the first one are added *at
random*, so there can be an accumulation of points in some species early on.

Note that this function is not particularly efficient, but this is a little bit
of over-head for every simulation. The only guarantee offered is that the
distances are not above the maximal distances in the dataset, there is no reason
to expect that the distribution of distances within or across taxa will be
respected.
"""
function bootstrap!(sim, layer, obs, obs_intra, obs_inter, sim_intra, sim_inter)
    max_intra = map(maximum, obs_intra)
    max_inter = map(maximum, obs_inter)

    # Get an initial point for each species, respecting the inter-specific distance constraint
    for i in 1:length(sim)
        sim[i][:, :] .= _generate_new_random_point(layer, obs[i], obs_intra[i])
    end
    Fauxcurrences.measure_interspecific_distances!(sim_inter, sim)
    while ~all(map(maximum, sim_inter) .<= max_inter)
        for i in 1:length(sim)
            sim[i][:, :] .= _generate_new_random_point(layer, obs[i], obs_intra[i])
        end
        Fauxcurrences.measure_interspecific_distances!(sim_inter, sim)
    end

    # Update the intra-specific distances
    Fauxcurrences.measure_intraspecific_distances!(sim_intra, sim)

    # How many points done?
    _progress = fill(1, length(sim))

    # Run'em occurrences fast
    while ~all(_progress .== size.(sim_intra, 2))
        updated_set = rand(findall(_progress .< size.(sim_intra, 2)))
        _position = _progress[updated_set]
        sim[updated_set][:, (_position+1):end] .= _generate_new_random_point(layer, sim[updated_set][:, 1:_position], obs_intra[updated_set])
        Fauxcurrences.measure_interspecific_distances!(sim_inter, sim)
        Fauxcurrences.measure_intraspecific_distances!(sim_intra, sim)
        while (~all(map(maximum, sim_inter) .<= max_inter)) & (~all(map(maximum, sim_intra) .<= max_intra))
            sim[updated_set][:, (_position+1):end] .= _generate_new_random_point(layer, sim[updated_set][:, 1:_position], obs_intra[updated_set])
            Fauxcurrences.measure_interspecific_distances!(sim_inter, sim)
            Fauxcurrences.measure_intraspecific_distances!(sim_intra, sim)
        end
        _progress[updated_set] += 1
    end
end

function preallocate_simulated_points(obs; samples=size.(obs,2))
    sim = [
        reshape(repeat(obs[i][:, 1], outer=samples[i]), (2, samples[i]))
        for i in 1:length(obs)
    ]
    return sim
end