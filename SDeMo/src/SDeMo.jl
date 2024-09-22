module SDeMo

using TestItems

import GLM
import StatsAPI
using Distributions
using MultivariateStats
using StatsBase
using Random
using Statistics
import JSON
using LinearAlgebra

# Demo data
include("utilities/demodata.jl")

# Types
include("models.jl")
export Transformer, Classifier
export SDM
export threshold, features, labels, variables

# Univariate transforms
include("transformers/univariate.jl")
export RawData, ZScore

include("transformers/multivariate.jl")
export MultivariateTransform

# Naive Bayes
include("classifiers/naivebayes.jl")
export NaiveBayes

# BIOCLIM
include("classifiers/bioclim.jl")
export BIOCLIM

# Bagging
include("bagging/bootstrap.jl")
include("bagging/pipeline.jl")
export Bagging, outofbag, bootstrap

# Main pipeline
include("pipeline.jl")
export reset!, train!, predict

# Cross-validation code
include("crossvalidation/confusionmatrix.jl")
export ConfusionMatrix
include("crossvalidation/crossvalidation.jl")
export leaveoneout, kfold, holdout, montecarlo
export crossvalidate
include("crossvalidation/null.jl")
export noskill, coinflip, constantnegative, constantpositive
include("crossvalidation/validation.jl")
export tpr, tnr, fpr, fnr, ppv, npv, fdir, fomr, plr, nlr, accuracy, balancedaccuracy
export ci

# Variable selection
include("variables/selection.jl")
export noselection!, forwardselection!, backwardselection!

# Explanations, etc
include("explanations/counterfactual.jl")
export counterfactual

include("explanations/shapley.jl")
export explain

include("utilities/show.jl")

end # module SDeMo
