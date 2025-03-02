"""
    SDeMo.SDM(::Type{TF}, ::Type{CF}, predictors::Vector{SDMLayer{T}}, presences::SDMLayer{Bool}, absences::SDMLayer{Bool}) where {TF <: Transformer, CF <: Classifier, T <: Number}

Returns a SDM based on an array of predictors, a boolean layer of presences, and
a boolean layer of absences.
"""
function SDeMo.SDM(
    ::Type{TF},
    ::Type{CF},
    predictors::Vector{SDMLayer{T}},
    presences::SDMLayer{Bool},
    absences::SDMLayer{Bool},
) where {TF <: Transformer, CF <: Classifier, T <: Number}
    pr = nodata(presences, false)
    ab = nodata(absences, false)
    ks = [keys(pr)..., keys(ab)...]
    X = Float32.([predictors[i][k] for i in eachindex(predictors), k in ks])
    y = [ones(Bool, sum(pr))..., zeros(Bool, sum(ab))...]
    return SDM(TF, CF, X, y)
end

"""
    TODO

Same as above but with a collection
"""
function SDeMo.SDM(
    ::Type{TF}, ::Type{CF},
    predictors::Vector{SDMLayer{T}},
    occurrences::OT,
) where {
    TF <: Transformer,
    CF <: Classifier,
    T <: Number,
    OT <: AbstractOccurrenceCollection,
}
    pr = nodata(mask(first(predictors), presences(occurrences)), false)
    ab = nodata(mask(first(predictors), absences(occurrences)), false)
    return SDM(TF, CF, predictpors, pr, ab)
end

function _X_from_layers(layers::Vector{T}) where {T <: SDMLayer}
    # Get the common grid positions
    ks = findall(reduce(.&, [layer.indices for layer in layers]))
    X = Float32.([layers[i][k] for i in eachindex(layers), k in ks])
    return X
end

function SDeMo.predict(
    model::S,
    layers::Vector{T},
    args...;
    kwargs...,
) where {S <: AbstractSDM, T <: SDMLayer}
    X = _X_from_layers(layers)
    prediction = predict(model, X, args...; kwargs...)
    pr = zeros(layers[1], eltype(prediction))
    pr.grid[findall(pr.indices)] .= prediction
    return pr
end

function SDeMo.partialresponse(
    sdm::ST,
    layers::Vector{T},
    idx::Integer;
    kwargs...,
) where {ST <: AbstractSDM, T <: SDMLayer}
    partrep = last(partialresponse(sdm, idx, values(layers[idx]); kwargs...))
    pr = zeros(layers[1], eltype(partrep))
    pr.grid[findall(pr.indices)] .= partrep
    return pr
end

function SDeMo.explain(
    sdm::ST,
    layers::Vector{T},
    idx::Integer;
    kwargs...,
) where {ST <: AbstractSDM, T <: SDMLayer}
    X = _X_from_layers(layers)
    expln = explain(sdm, idx; instances = X, kwargs...)
    pr = zeros(layers[1], eltype(expln))
    pr.grid[findall(pr.indices)] .= expln
    return pr
end

function SDeMo.explain(
    sdm::ST,
    layers::Vector{T};
    kwargs...,
) where {ST <: AbstractSDM, T <: SDMLayer}
    return [explain(sdm, layers, v; kwargs...) for v in variables(sdm)]
end

# @testitem "We can get Shapley values on a different layer than was used for training" begin
#     provider = RasterData(CHELSA2, BioClim)
#     orig_layers = [
#         SDMLayer(provider; layer = x, left = 10.0, right = 12.0, bottom = 35.0, top = 37.0) for x in [1, 12]
#     ]
#     transfer_layers = [
#         SDMLayer(provider; layer = x, left = 11.8, right = 12.0, bottom = 55.8, top = 56.0) for x in [1, 12]
#     ]
#     prs = unique(rand(keys(orig_layers[1]), 800))
#     abc = unique(rand(keys(orig_layers[1]), 800))
#     P = zeros(orig_layers[1], Bool)
#     A = zeros(orig_layers[1], Bool)
#     for p in prs
#         P[p] = true
#     end
#     for a in abc
#         A[a] = true
#     end
#     sdm = SDM(ZScore, NaiveBayes, orig_layers, P, A)
#     train!(sdm)
#     @test explain(sdm, transfer_layers, 1) isa SDMLayer
# end