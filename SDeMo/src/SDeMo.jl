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

This returns the value above which the score returned by the SDM is considered
to be a presence.
"""
threshold(sdm::SDM) = sdm.τ

"""
    features(sdm::SDM)

Returns the features stored in the field `X` of the SDM. Note that the features
are an array, and this does not return a copy of it -- any change made to the
output of this function *will* change the content of the SDM features.
"""
features(sdm::SDM) = sdm.X

"""
    labels(sdm::SDM)

Returns the labels stored in the field `y` of the SDM -- note that this is not a
copy of the labels, but the object itself.
"""
labels(sdm::SDM) = sdm.y

"""
    variables(sdm::SDM)

Returns the list of variables used by the SDM -- these *may* be ordered by
importance. This does not return a copy of the variables array, but the array
itself.
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
