"""
    AbstractSDM

This abstract type covers the regular, ensemble, and boosted models.
"""
abstract type AbstractSDM end

"""
    AbstractEnsembleSDM

This abstract types covers model that combine different SDMs to make a
prediction, which currently covers `Bagging` and `Ensemble`.
"""
abstract type AbstractEnsembleSDM <: AbstractSDM end

"""
    AbstractBoostedSDM

This type covers model that use boosting to iteratively improve on the least
well predicted instances of a problem.
"""
abstract type AbstractBoostedSDM <: AbstractSDM end

"""
    Transformer

This abstract type covers all transformations that are applied to the data
before fitting the classifier.
"""
abstract type Transformer end

"""
    Classifier

This abstract type covers all algorithms to convert transformed data into
prediction.
"""
abstract type Classifier end

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
mutable struct SDM{F, L} <: AbstractSDM
    transformer::Transformer
    classifier::Classifier
    τ::Number # Threshold
    X::Matrix{F} # Features
    y::Vector{L} # Labels
    v::AbstractVector # Variables
    coordinates::Vector{Tuple{<:Number, <:Number}}
end

function SDM(
    ::Type{TF},
    ::Type{CF},
    X::Matrix{T},
    y::Vector{Bool},
) where {TF <: Transformer, CF <: Classifier, T <: Number}
    return SDM(
        TF(),
        CF(),
        zero(CF),
        X,
        y,
        collect(1:size(X, 1)),
        Tuple{Float64, Float64}[]
    )
end

"""
    isgeoreferenced(sdm::SDM)

Returns `true` if an SDM is georeferenced, _i.e._ if the `coordinates` field is
not empty.
"""
function isgeoreferenced(sdm::SDM)
    return !isempty(sdm.coordinates)
end

@testitem "We can create a SDM without geospatial references" begin
    X, y = SDeMo.__demodata()
    model = SDM(RawData, NaiveBayes, X, y)
    @test !isgeoreferenced(model)
end

"""
    threshold(sdm::SDM)

This returns the value above which the score returned by the SDM is considered
to be a presence.
"""
threshold(sdm::SDM) = sdm.τ

"""
    threshold!(sdm::SDM, τ)

Sets the value of the threshold.
"""
threshold!(sdm::SDM, τ) = sdm.τ = τ

"""
    features(sdm::SDM)

Returns the features stored in the field `X` of the SDM. Note that the features
are an array, and this does not return a copy of it -- any change made to the
output of this function *will* change the content of the SDM features.
"""
features(sdm::SDM) = sdm.X

"""
    features(sdm::SDM, n)

Returns the *n*-th feature stored in the field `X` of the SDM.
"""
features(sdm::SDM, n) = sdm.X[n, :]

"""
    instance(sdm::SDM, n; strict=true)

Returns the *n*-th instance stored in the field `X` of the SDM. If the keyword
argument `strict` is `true`, only the variables used for prediction are
returned.
"""
function instance(sdm::SDM, n; strict = true)
    if strict
        return features(sdm)[variables(sdm), n]
    else
        return features(sdm)[:, n]
    end
end

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

"""
    variables!(sdm::SDM, v)

Sets the list of variables.
"""
variables!(sdm::SDM, v::Vector{Int}) = sdm.v = copy(v)

"""
    transformer(model::SDM)

Returns the transformer used by the model
"""
transformer(model::SDM) = model.transformer

"""
    classifier(model::SDM)

Returns the classifier used by the model
"""
classifier(model::SDM) = model.classifier
