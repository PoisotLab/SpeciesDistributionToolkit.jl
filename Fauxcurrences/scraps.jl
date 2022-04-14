using Revise
using Fauxcurrences
using Plots
using SimpleSDMLayers
using GBIF
using Statistics
using ProgressMeter

# Use the Sulawesi example from the original paper
_bbox = (left=108., right=126.5, bottom=-7., top=8.)
layer = convert(Float32, SimpleSDMPredictor(WorldClim, Elevation; _bbox..., resolution=0.5))
plot(layer, frame=:box, c=:bamako, dpi=400)
_taxnames = "Cyrtandra " .* ["bruteliana", "celebica", "geocarpa", "hypogaea", "polyneura", "widjajae"]
taxa = [
    GBIF.taxon(_tn; strict=true) for _tn in _taxnames
]

observations = []
for t in taxa
    obs = occurrences(t,
        "hasCoordinate" => "true",
        "decimalLatitude" => (_bbox.bottom, _bbox.top),
        "decimalLongitude" => (_bbox.left, _bbox.right),
        "limit" => 200)
    push!(observations, obs)
end

# TODO: we can probably definitely thin the points in order to be within 1% of
# the empirical distribution, which would be a lot faster,

# TODO: we can set how many samples we actually want for the null model, which
# might also be much faster (or compensate lacks in data)

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

progress = zeros(Float64, 500_000)
scores = zeros(Float64, (length(D), length(progress)))
scores[:, 1] .= D
progress[1] = optimum

max_intra = map(maximum, obs_intra)
max_inter = map(maximum, obs_inter)

p = Progress(length(progress); showspeed=true)
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
        sim[updated_set][:, _position] .= Fauxcurrences._generate_new_random_point(layer, current_point, obs_intra[updated_set])
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
        #@info "t = $(lpad(i, 8)) \t λ = $(round(optimum; digits=6))"
    else
        sim[updated_set][:, _position] .= current_point
    end
    ProgressMeter.next!(p; showvalues=[(:optimum, optimum)])
    progress[i] = optimum
end

# TODO: see if there is a weighted version of the JS divergence, in which case
# use this based on a species x species matrix of association score

# Performance change plot
#plot(scores[1:length(sim), :]', lab="", frame=:box, c=:grey, dpi=400)
#plot!(scores[(length(sim)+1):end, :]', lab="", c=:lightgrey)
plot(progress, c=:black, lw=2, lab="Overall")
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
