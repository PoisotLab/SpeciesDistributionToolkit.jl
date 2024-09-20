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

"""
    Transformer

TODO
"""
abstract type Transformer end
export Transformer

"""
    Classifier

TODO
"""
abstract type Classifier end
export Classifier

"""
    SDM

This type specifies a *full* model, which is composed of a transformer (which
applies a transformation on the data), a classifier (which returns a
quantitative score), a threshold (above which the score corresponds to the
prediction of a presence).

In addition, the SDM carries with it the training features and labels, as well
as a vector of indices indicating which variables are actually used by the
model.
"""
mutable struct SDM{F,L}
    transformer::Transformer
    classifier::Classifier
    τ::Number # Threshold
    X::Matrix{F} # Features
    y::Vector{L} # Labels
    v::AbstractVector # Variables
end
export SDM

"""
    threshold(sdm::SDM)
"""
threshold(sdm::SDM) = sdm.τ

"""
    features(sdm::SDM)
"""
features(sdm::SDM) = sdm.X

"""
    labels(sdm::SDM)
"""
labels(sdm::SDM) = sdm.y

"""
    variables(sdm::SDM)
"""
variables(sdm::SDM) = sdm.v
export threshold, features, labels, variables

include("transformers/univariate.jl")
export RawData, ZScore

include("classifiers/naivebayes.jl")
export NaiveBayes

include("classifiers/bioclim.jl")
export BIOCLIM

include("pipeline.jl")
export train!

include("bagging/bootstrap.jl")
include("bagging/pipeline.jl")
export Bagging, outofbag, bootstrap


end # module SDeMo
