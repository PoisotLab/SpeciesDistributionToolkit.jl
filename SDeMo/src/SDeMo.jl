module SDeMo

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

"""
    Classifier

TODO
"""
abstract type Classifier end

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

export Transformer
export Classifier
export SDM

# RawData, ZScore
include("pipelines/univariatetransforms.jl")
export RawData, ZScore

end # module SDeMo
