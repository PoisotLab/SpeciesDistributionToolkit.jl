module SDeMo

using TestItems

import GLM
import StatsAPI
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

TODO
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

threshold(sdm::SDM) = sdm.τ
features(sdm::SDM) = sdm.X
labels(sdm::SDM) = sdm.y
variables(sdm::SDM) = sdm.v
export threshold, features, labels, variables

# RawData, ZScore
include("pipelines/univariatetransforms.jl")
export RawData, ZScore

end # module SDeMo
