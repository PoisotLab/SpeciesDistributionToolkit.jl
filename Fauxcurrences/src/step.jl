function step!(sim, layer, W, obs_intra, obs_inter, sim_intra, sim_inter, bin_intra, bin_inter, bin_s_intra, bin_s_inter, distance)
    # Get a random set of points to change
    updated_set = rand(1:length(sim))

    # Get a random point to change in the layer
    _position = rand(1:size(sim[updated_set], 2))

    # Save the old point
    current_point = sim[updated_set][:, _position]

    # Generate a new proposition
    sim[updated_set][:, _position] .= Fauxcurrences._generate_new_random_point(layer, current_point, obs_intra[updated_set])
    Fauxcurrences.measure_interspecific_distances!(sim_inter, sim; updated=updated_set)
    Fauxcurrences.measure_intraspecific_distances!(sim_intra, sim; updated=updated_set)
    while (~all(map(maximum, sim_inter) .<= map(maximum, obs_inter))) & (~all(map(maximum, sim_intra) .<= map(maximum, obs_intra)))
        sim[updated_set][:, _position] .= Fauxcurrences._generate_new_random_point(layer, current_point, obs_intra[updated_set])
        Fauxcurrences.measure_interspecific_distances!(sim_inter, sim; updated=updated_set)
        Fauxcurrences.measure_intraspecific_distances!(sim_intra, sim; updated=updated_set)
    end

    # Get the bins for the simulated distance matrices - note that the upper bound is always the observed maximum
    [Fauxcurrences._bin_distribution!(bin_s_intra[i], sim_intra[i], maximum(obs_intra[i])) for i in 1:length(obs_intra)]
    [Fauxcurrences._bin_distribution!(bin_s_inter[i], sim_inter[i], maximum(obs_inter[i])) for i in 1:length(obs_inter)]

    # Measure the divergences
    D = Fauxcurrences.score_distributions(W, bin_intra, bin_s_intra, bin_inter, bin_s_inter)
    candidate = sum(D)

    if candidate < distance
        return candidate
    else
        sim[updated_set][:, _position] .= current_point
        return distance
    end
    
end 