"""
    SDeMo.SDM(::Type{TF}, ::Type{CF}, predictors::Vector{SDMLayer{T}}, presences::SDMLayer{Bool}, absences::SDMLayer{Bool}) where {TF <: Transformer, CF <: Classifier, T <: Number}

Returns a SDM based on an array of predictors, a boolean layer of presences, and
a boolean layer of absences.
"""
function SDeMo.SDM(::Type{TF}, ::Type{CF}, predictors::Vector{SDMLayer{T}}, presences::SDMLayer{Bool}, absences::SDMLayer{Bool}) where {TF <: Transformer, CF <: Classifier, T <: Number}
    pr = nodata(presences, false)
    ab = nodata(absences, false)
    ks = [keys(pr)..., keys(ab)...]
    X = Float32.([predictors[i][k] for i in eachindex(predictors), k in ks])
    y = [ones(Bool, sum(pr))..., zeros(Bool, sum(ab))...]
    return SDM(TF, CF, X, y)
end

function _X_from_layers(layers::Vector{T}) where {T <: SDMLayer}
    # Get the common grid positions
    ks = findall(reduce(.&, [layer.indices for layer in layers]))
    X = Float32.([layers[i][k] for i in eachindex(layers), k in ks])
    return X
end

# TODO SDM, Bagging, and Ensemble should be AbstractSDM

function SDeMo.predict(sdm::SDM, layers::Vector{T}, args...; kwargs...) where {T <: SDMLayer}
    X = _X_from_layers(layers)
    prediction = predict(sdm, X, args...; kwargs...)
    pr = zeros(layers[1], eltype(prediction))
    pr.grid[findall(pr.indices)] .= prediction
    return pr
end

function SDeMo.predict(sdm::Bagging, layers::Vector{T}, args...; kwargs...) where {T <: SDMLayer}
    X = _X_from_layers(layers)
    prediction = predict(sdm, X, args...; kwargs...)
    pr = zeros(layers[1], eltype(prediction))
    pr.grid[findall(pr.indices)] .= prediction
    return pr
end

function SDeMo.partialresponse(sdm::SDM, layers::Vector{T}, idx::Integer; kwargs...) where {T <: SDMLayer}
    partrep = partialresponse(sdm, idx, values(layers[idx]); kwargs...)[end]
    pr = zeros(layers[1], eltype(partrep))
    pr.grid[findall(pr.indices)] .= partrep
    return pr
end

function SDeMo.explain(sdm::SDM, layers::Vector{T}, idx::Integer; kwargs...) where {T <: SDMLayer}
    X = _X_from_layers(layers)
    expln = explain(sdm, idx; instances=X, kwargs...)
    pr = zeros(layers[1], eltype(expln))
    pr.grid[findall(pr.indices)] .= expln
    return pr
end