# # BRTs

using SimpleSDMLayers
using EvoTrees
using GBIF
using StatsBase
using Plots

#-

sp = GBIF.taxon("Hypomyces lactifluorum")
observations = occurrences(sp, "hasCoordinate" => true, "limit" => 300, "country" => "CA", "country" => "US")
while length(observations) < size(observations)
    occurrences!(observations)
end

#- 

layers = [clip(layer, observations) for layer in SimpleSDMPredictor(WorldClim, BioClim, 1:19)]

#-

presences = mask(layers[1], observations, Bool)
absences = rand(SurfaceRangeEnvelope, presences)

#-

xy_presence = keys(replace(presences, false => nothing))
xy_absence = keys(replace(absences, false => nothing))
xy = vcat(xy_presence, xy_absence)

#-

X = hcat([layer[xy] for layer in layers]...)
y = vcat(fill(1.0, length(xy_presence)), fill(0.0, length(xy_absence)))

#-

train_size = floor(Int, 0.7*length(y))
train_idx = sample(1:length(y), train_size, replace=false)
test_idx = setdiff(1:length(y), train_idx)

#-

Xtrain, Xtest = X[train_idx, :], X[test_idx, :]
Ytrain, Ytest = y[train_idx], y[test_idx]

#-

params1 = EvoTreeGaussian(
    loss=:gaussian, metric=:gaussian,
    nrounds=100, nbins=100,
    λ = 0.0, γ=0.0, η=0.1,
    max_depth = 6, min_weight = 1.0,
    rowsample=0.5, colsample=1.0)

#-

model = fit_evotree(params1, Xtrain, Ytrain, X_eval = Xtest, Y_eval = Ytest, print_every_n = 25)
pred = EvoTrees.predict(model, all_values)

#-

distribution = similar(layers[1], Float64)
distribution[keys(distribution)] = pred[:,1]

#-

uncertainty = similar(layers[1], Float64)
uncertainty[keys(uncertainty)] = pred[:,2]

#-

default(; frame=:box, size=(800,300))

#-

p_dis = plot(rescale(distribution, (0,1)), c=:bamako)

#-
p_unc = plot(uncertainty, c=:bilbao)
