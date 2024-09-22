function __tosymbol(cl::Type{T}) where T <: Classifier
    str = string(cl)
    contains(str, "NaiveBayes") && return :NaiveBayes
    contains(str, "BioClim") && return :BioClim
    return :NaiveBayes
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
    s == :NaiveBayes && return NaiveBayes
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

"""
    writesdm(file::String, model::SDM)

Writes a model to a `JSON` file. This method is very bare-bones, and only saves
the *structure* of the model, as well as the data.
"""
function writesdm(file::String, model::SDM)
    open(file, "w") do f
        JSON.print(f, _sdm_to_dict(model), 4)
    end
end

"""
    loadsdm(file::String; kwargs...)

Loads a model to a `JSON` file. The keyword arguments are passed to `train!`.
The model is trained in full upon loading.
"""
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

@testitem "We can write a model and load it back" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(MultivariateTransform{PCA}(), BIOCLIM(), 0.5, X, y, [1,2,12])
    train!(sdm)
    tf = tempname()
    writesdm(tf, sdm)
    nsdm = loadsdm(tf; threshold=false)
    @test threshold(sdm) == threshold(nsdm)
    @test variables(sdm) == variables(nsdm)
    @test labels(sdm) == labels(nsdm)
    @test features(sdm) == features(nsdm)
end