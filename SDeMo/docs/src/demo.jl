# # A demonstration

# The purpose of this vignette is to take a whistle-stop tour of the what the
# package has to offer.

using SDeMo
using Statistics
using CairoMakie
using PrettyTables
CairoMakie.activate!(; px_per_unit=3) #hide

# load the demo data

X, y = SDeMo.__demodata();

# preapre a PCA + NBC

sdm = SDM(MultivariateTransform{PCA}(), NaiveBayes(), 0.5, X, y, 1:size(X, 1))

# get the folds for the rest of the demo

folds = kfold(sdm; k=10);

# cross-validate to get baseline performance

cv = crossvalidate(sdm, folds)

# mcc 

mcc.(cv.validation)

# for training

mcc.(cv.training)

# get some variable selection going

forwardselection!(sdm, folds, [1])

# variables

variables(sdm)

# cross-validate again

cv2 = crossvalidate(sdm, folds)

#

mcc.(cv2.validation)

# importance of variables

varimp = mean.(variableimportance(sdm, folds))

# rel

varimp ./ sum(varimp)

# TODO table

# why prediction

[explain(sdm, v; observation=3) for v in variables(sdm)]

# response curve shapley

f = Figure()
ax = Axis(f[1,1], xlabel="BIO8", ylabel="Effect on the average prediction")
scatter!(ax, features(sdm, 8), explain(sdm, 8; threshold=true), color=:purple)
current_figure() #hide

# partial response curve

nX = zeros(Float64, (19, 300))
for i in axes(nX, 1)
    if i == 1
        nX[i,:] .= LinRange(extrema(features(sdm, i))..., size(nX, 2))
    else
        nX[i,:] .= mean(features(sdm, i))
    end
end

# figure

f = Figure()
ax = Axis(f[1,1], xlabel="BIO1", ylabel="Partial response")
lines!(ax, nX[1,:], predict(sdm, nX; threshold=false), color=:black)
current_figure() #hide

# pick a prediction and flip it

inst = 4
outcome = predict(sdm)[inst]
target = outcome ? 0.9threshold(sdm) : 1.1threshold(sdm)
cf = counterfactual(sdm, instance(sdm, inst; strict=false), target, 200.0; threshold=false)
predict(sdm, cf)

# conclusion what have we learned