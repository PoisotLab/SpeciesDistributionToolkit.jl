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
export threshold, features, labels, variables, instance
export threshold!, variables!

# Univariate transforms
include("transformers/univariate.jl")
export RawData, ZScore

include("transformers/multivariate.jl")
export MultivariateTransform
export PCA, PPCA, KernelPCA, Whitening

# Naive Bayes
include("classifiers/naivebayes.jl")
export NaiveBayes

# BIOCLIM
include("classifiers/bioclim.jl")
export BIOCLIM

# Bagging and ensembles
include("ensembles/bagging.jl")
export Bagging, outofbag, bootstrap

include("ensembles/ensemble.jl")
export Ensemble

include("ensembles/pipeline.jl")

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
export tpr, tnr, fpr, fnr
export ppv, npv, fdir, fomr, plr, nlr
export accuracy, balancedaccuracy, f1, fscore
export trueskill, markedness, dor, κ, mcc
export ci

# Variable selection
include("variables/selection.jl")
export noselection!, forwardselection!, backwardselection!

include("variables/importance.jl")
export variableimportance

# Explanations, etc
include("explanations/counterfactual.jl")
export counterfactual

include("explanations/partialresponse.jl")
export partialresponse

include("explanations/shapley.jl")
export explain

include("utilities/show.jl")
include("utilities/io.jl")
export writesdm, loadsdm

include("utilities/varia.jl")
export iqr

end # module SDeMo
