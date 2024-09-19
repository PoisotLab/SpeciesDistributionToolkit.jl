function __tosymbol(cl::Type{T}) where T <: Classifier
    str = string(cl)
    contains(str, "NBC") && return :NBC
    contains(str, "BioClim") && return :BioClim
    return :NBC
end

function __tosymbol(tr::Type{T}) where T <: Transformer
    str = string(tr)
    contains(str, "PCA") && return Symbol("MultivariateTransform{PCA}")
    contains(str, "Whitening") && return Symbol("MultivariateTransform{Whitening}")
    contains(str, "ZScore") && return :ZScore
    return :RawData
end

function __fromsymbol(s)
    s == :RawData && return RawData
    s == :ZScore && return ZScore
    s == Symbol("MultivariateTransform{PCA}") && return MultivariateTransform{PCA}
    s == Symbol("MultivariateTransform{Whitening}") && return MultivariateTransform{Whitening}
    s == :NBC && return NBC
    s == :BioClim && return BioClim
end

function _sdm_to_dict(sdm::SDM)
    w = Dict()
    w["threshold"] = sdm.τ
    w["variables"] = sdm.v
    w["labels"] = sdm.y
    w["instances"] = sdm.X
    w["classifier"] = __tosymbol(typeof(sdm.classifier))
    w["transformer"] = __tosymbol(typeof(sdm.transformer))
    return w
end

function writesdm(file::String, model::SDM)
    open(file, "w") do f
        JSON.print(f, _sdm_to_dict(model), 4)
    end
end

function loadsdm(file::String; kwargs...)
    f = JSON.parsefile(file)
    X = hcat(f["instances"]...)
    y = convert(Vector{Bool}, (f["labels"]))
    v = convert(Vector{Int}, f["variables"])
    τ = f["threshold"]
    classifier = __fromsymbol(Symbol(f["classifier"]))()
    transformer = __fromsymbol(Symbol(f["transformer"]))()
    model = SDM(transformer, classifier, τ, X, y, v)
    train!(model; kwargs...)
    return model
end