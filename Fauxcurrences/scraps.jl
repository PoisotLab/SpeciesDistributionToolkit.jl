using Revise
using Fauxcurrences
using Plots
using SimpleSDMLayers
using GBIF
using Statistics

_bbox = (left=-160.0, right=-154.5, bottom=18.5, top=22.5)
layer = convert(Float32, SimpleSDMPredictor(WorldClim, Elevation; _bbox..., resolution=0.5))
plot(layer, frame=:box, c=:bamako, dpi=400)
taxa = [
    GBIF.taxon("Himatione sanguinea"; strict=true),
    GBIF.taxon("Paroaria capitata"; strict=true),
    GBIF.taxon("Pluvialis fulva"; strict=true)
]

observations = []
for t in taxa
    obs = occurrences(t,
        "hasCoordinate" => "true",
        "decimalLatitude" => (_bbox.bottom, _bbox.top),
        "decimalLongitude" => (_bbox.left, _bbox.right),
        "limit" => 300)
    push!(observations, obs)
end

# Generate the observation distances
obs = [Fauxcurrences.get_valid_coordinates(obs, layer) for obs in observations]

# Pre-allocate the matrices
obs_intra, obs_inter, sim_intra, sim_inter = Fauxcurrences.preallocate_distance_matrices(obs)

# Fill the observed distance matrices
Fauxcurrences.initialize_intraspecific_distances!(obs_intra, obs)
Fauxcurrences.initialize_interspecific_distances!(obs_inter, obs)

# Bootstrap!
sim = [copy(o) for o in obs]
@time Fauxcurrences.bootstrap!(sim, layer, obs, obs_intra, obs_inter, sim_intra, sim_inter)

# Measure the initial divergences
d_intra = [Fauxcurrences._distance_between_distributions(obs_intra[i], sim_intra[i]) for i in 1:length(sim_intra)]
d_inter = [Fauxcurrences._distance_between_distributions(obs_inter[i], sim_inter[i]) for i in 1:length(sim_inter)]
D = vcat(d_intra, d_inter)
optimum = mean(D)

progress = zeros(Float64, 1_000)
scores = zeros(Float64, (length(D), length(progress)))
scores[:, 1] .= D
progress[1] = optimum

max_intra = map(maximum, obs_intra)
max_inter = map(maximum, obs_inter)

for i in 2:length(progress)
    # Get a random set of points to change
    updated_set = rand(1:length(sim))

    # Get a random point to change in the layer
    _position = rand(1:size(sim[updated_set], 2))

    # Save the old point
    current_point = sim[updated_set][:, _position]

    # Generate a new proposition
    sim[updated_set][:, _position] .= Fauxcurrences._generate_new_random_point(layer, current_point, obs_intra[updated_set])
    Fauxcurrences.initialize_interspecific_distances!(sim_inter, sim)
    Fauxcurrences.initialize_intraspecific_distances!(sim_intra, sim)
    while (~all(map(maximum, sim_inter) .<= max_inter)) & (~all(map(maximum, sim_intra) .<= max_intra))
        sim[updated_set][:, (_position+1):end] .= _generate_new_random_point(layer, sim[updated_set][:, 1:_position], obs_intra[updated_set])
        Fauxcurrences.initialize_interspecific_distances!(sim_inter, sim)
        Fauxcurrences.initialize_intraspecific_distances!(sim_intra, sim)
    end

    d_intra = [Fauxcurrences._distance_between_distributions(obs_intra[i], sim_intra[i]) for i in 1:length(sim_intra)]
    d_inter = [Fauxcurrences._distance_between_distributions(obs_inter[i], sim_inter[i]) for i in 1:length(sim_inter)]
    D = vcat(d_intra, d_inter)
    candidate = mean(D)

    scores[:, i] .= D

    if candidate < optimum
        optimum = candidate
        @info "t = $(lpad(i, 8)) λ = $(round(optimum; digits=4))"
    else
        sim[updated_set][:, _position] .= current_point
    end
    progress[i] = optimum
end

# Performance change plot
plot(scores[1:length(sim), :]', lab="", frame=:box, c=:grey)
plot!(scores[(length(sim)+1):end, :]', lab="", c=:lightgrey)
plot!(progress, c=:black, lw=2, lab="Overall")
xaxis!("Iteration step")
yaxis!("Absolute performance")

# Map
p = [plot(layer, frame=:grid, c=:grey, cbar=false, legend=:bottomleft, size=(800, 600), dpi=600) for i in 1:length(sim), j in 1:2]
c = distinguishable_colors(length(sim) + 4)[(end-length(sim)+1):end]
for i in 1:length(sim)
    scatter!(p[i, 1], obs[i][1, :], obs[i][2, :], lab="", ms=2, c=c[i], msw=0.0)
    scatter!(p[i, 2], sim[i][1, :], sim[i][2, :], lab="", ms=2, c=c[i], msw=0.0, m=:diamond)
end
plot(p..., layout=(2, length(sim)))
savefig("demo.png")
