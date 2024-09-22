"""
    SDeMo.SDM(::Type{TF}, ::Type{CF}, predictors::Vector{SDMLayer{T}}, presences::SDMLayer{Bool}, absences::SDMLayer{Bool}) where {TF <: Transformer, CF <: Classifier, T <: Number}

Returns a SDM based on an array of predictors, a boolean layer of presences, and
a boolean layer of absences.
"""
function SDeMo.SDM(::Type{TF}, ::Type{CF}, predictors::Vector{SDMLayer{T}}, presences::SDMLayer{Bool}, absences::SDMLayer{Bool}) where {TF <: Transformer, CF <: Classifier, T <: Number}
    pr = nodata(presences, false)
    ab = nodata(absences, false)
    ks = [keys(pr)..., keys(ab)...]
    X = Float32.([predictors[i][k] for k in ks, i in eachindex(predictors)])
    y = [ones(Bool, sum(pr))..., zeros(Bool, sum(ab))...]
    return SDM(TF, CF, X, y)
end

function _X_from_layers(layers::Vector{T}) where {T <: SDMLayer}
    # Get the common grid positions
    k = reduce(.&, [layer.indices for layer in layers])
    raw = [layer.grid[findall(k)] for layer in layers]

    
    
end

function SDeMo.predict(sdm::SDM, layers::Vector{T}; kwargs...) where {T <: SDMLayer}
    pr = convert(Float64, similar(first(layers)))
    F = permutedims(hcat(values.(layers)...))
    pr.grid[findall(!isnothing, layers[1].grid)] .= predict(sdm, F; kwargs...)
    return pr
end

function SDeMo.predict(ensemble::Bagging, layers::Vector{T}; kwargs...) where {T <: SDMLayer}
    pr = convert(Float64, similar(first(layers)))
    F = permutedims(hcat(values.(layers)...))
    pr.grid[findall(!isnothing, layers[1].grid)] .= predict(ensemble, F; kwargs...)
    return pr
end

function SDeMo.predict(ensemble::Ensemble, layers::Vector{T}; kwargs...) where {T <: SDMLayer}
    pr = convert(Float64, similar(first(layers)))
    F = permutedims(hcat(values.(layers)...))
    pr.grid[findall(!isnothing, layers[1].grid)] .= predict(ensemble, F; kwargs...)
    return pr
end