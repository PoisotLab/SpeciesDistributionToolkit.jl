using Revise
using Fauxcurrences
using Plots
using SimpleSDMLayers
using GBIF

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
# TODO: make this a function!
obs_intra_matrices = [zeros(Float64, (size(obs[i], 2), size(obs[i], 2))) for i in 1:length(obs)]
obs_inter_matrices = [zeros(Float64, (size(obs[i], 2), size(obs[j], 2))) for i in 1:(length(obs)-1) for j in (i+1):length(obs)]
sim_intra_matrices = [zeros(Float64, (size(obs[i], 2), size(obs[i], 2))) for i in 1:length(obs)]
sim_inter_matrices = [zeros(Float64, (size(obs[i], 2), size(obs[j], 2))) for i in 1:(length(obs)-1) for j in (i+1):length(obs)]

for i in 1:length(obs)
    Distances.pairwise!(obs_intra_matrices[i], Fauxcurrences._distancefunction, obs[i])
end
cursor = 1
for i in 1:(length(obs)-1)
    for j in (i+1):length(obs)
        Distances.pairwise!(obs_inter_matrices[cursor], Fauxcurrences._distancefunction, obs[i], obs[j])
        cursor += 1
    end
end

# Generate the simulation distances
sim = [generate_initial_points(layer, obs[i], obs_intra_matrices[i]) for i in 1:length(obs)]
for i in 1:length(sim)
    pairwise!(sim_intra_matrices[i], Df, sim[i])
end
cursor = 1
for i in 1:(length(sim)-1)
    for j in (i+1):length(sim)
        pairwise!(sim_inter_matrices[cursor], Df, sim[i], sim[j])
        cursor += 1
    end
end

JSintra = [distribution_distance(obs_intra_matrices[i], sim_intra_matrices[i]) for i in 1:length(sim_intra_matrices)]
JSinter = [distribution_distance(obs_inter_matrices[i], sim_inter_matrices[i]) for i in 1:length(sim_inter_matrices)]
JS = vcat(JSintra, JSinter)
optimum = mean(JS)

progress = zeros(Float64, 200_000)
scores = zeros(Float64, (length(JS), length(progress)))
scores[:, 1] .= JS
progress[1] = optimum

for i in 2:length(progress)
    # Get a random set of points to change
    set_to_change = rand(1:length(sim))

    # Get a random point to change in the layer
    point_to_change = rand(1:size(sim[set_to_change], 2))

    # Save the old point
    current_point = sim[set_to_change][:, point_to_change]

    # Generate a new proposition
    sim[set_to_change][:, point_to_change] .= new_random_point(layer, current_point, obs_intra_matrices[set_to_change])

    # Update the distance matrices
    pairwise!(sim_intra_matrices[set_to_change], Df, sim[set_to_change])
    cursor = 1
    for i in 1:(length(sim)-1)
        for j in (i+1):length(sim)
            # Only update the matrices for which there was a change
            if (i == set_to_change) || (j == set_to_change)
                pairwise!(sim_inter_matrices[cursor], Df, sim[i], sim[j])
            end
            cursor += 1
        end
    end

    JSintra = [distribution_distance(obs_intra_matrices[i], sim_intra_matrices[i]) for i in 1:length(sim_intra_matrices)]
    JSinter = [distribution_distance(obs_inter_matrices[i], sim_inter_matrices[i]) for i in 1:length(sim_inter_matrices)]
    JS = vcat(JSintra, JSinter)

    d0 = mean(JS)
    scores[:, i] .= JS

    if d0 < optimum
        optimum = d0
        @info "t = $(lpad(i, 8)) λ = $(round(optimum; digits=4))"
    else
        sim[set_to_change][:, point_to_change] .= current_point
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
