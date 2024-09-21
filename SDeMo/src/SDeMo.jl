module SDeMo

using TestItems

import GLM
import StatsAPI
using Distributions
import MultivariateStats
using StatsBase
using Random
using Statistics
import JSON
using LinearAlgebra

# Types
include("models.jl")
export Transformer, Classifier
export SDM
export threshold, features, labels, variables

# Univariate transforms
include("transformers/univariate.jl")
export RawData, ZScore

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


end # module SDeMo
