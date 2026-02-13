function __tosymbol(cl::Type{T}) where {T <: Classifier}
    str = string(cl)
    contains(str, "NaiveBayes") && return :NaiveBayes
    contains(str, "BioClim") && return :BioClim
    contains(str, "DecisionTree") && return :DecisionTree
    contains(str, "Logistic") && return :Logistic
    return :NaiveBayes
end

function __tosymbol(tr::Type{T}) where {T <: Transformer}
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
    s == Symbol("MultivariateTransform{Whitening}") &&
        return MultivariateTransform{Whitening}
    s == :NaiveBayes && return NaiveBayes
    s == :DecisionTree && return DecisionTree
    s == :BioClim && return BioClim
    s == :Logistic && return Logistic
end

function _sdm_to_dict(sdm::SDM)
    w = Dict()
    w["threshold"] = sdm.τ
    w["variables"] = sdm.v
    w["labels"] = sdm.y
    w["instances"] = sdm.X
    w["classifier"] = __tosymbol(typeof(sdm.classifier))
    w["transformer"] = __tosymbol(typeof(sdm.transformer))
    hparams = Dict()
    if !isnothing(hyperparameters(transformer(sdm)))
        hparams["transformer"] = hyperparameters(transformer(sdm))
    end
    if !isnothing(hyperparameters(classifier(sdm)))
        hparams["classifier"] = hyperparameters(classifier(sdm))
    end
    if !isempty(hparams)
        w["hyperparameters"] = hparams
    end
    return w
end

"""
    writesdm(file::String, model::SDM)

Writes a model to a `JSON` file. This method is very bare-bones, and only saves
the *structure* of the model, as well as the data.
"""
function writesdm(file::String, model::SDM)
    open(file, "w") do f
        return JSON.print(f, _sdm_to_dict(model), 4)
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
    CLS = __fromsymbol(Symbol(f["classifier"]))()
    TRF = __fromsymbol(Symbol(f["transformer"]))()
    model = SDM(TRF, CLS, τ, X, y, v)
    # Hyper parameters
    if "hyperparameters" in keys(f)
        if "classifier" in keys(f["hyperparameters"])
            for (k, v) in f["hyperparameters"]["classifier"]
                sk = Symbol(k)
                T = typeof(hyperparameters(classifier(model), sk))
                hyperparameters!(classifier(model), sk, T(v))
            end
        end
        if "transformer" in keys(f["hyperparameters"])
            for (k, v) in f["hyperparameters"]["trasnformer"]
                sk = Symbol(k)
                T = typeof(hyperparameters(transformer(model), sk))
                hyperparameters!(transformer(model), sk, T(v))
            end
        end
    end
    train!(model; kwargs...)
    return model
end

@testitem "We can write a model with no hyper-parameters and load it back" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(RawData, BIOCLIM, X, y)
    variables!(sdm, [1, 2, 12])
    train!(sdm)
    tf = tempname()
    writesdm(tf, sdm)
    nsdm = loadsdm(tf; threshold = false)
    @test threshold(sdm) == threshold(nsdm)
    @test variables(sdm) == variables(nsdm)
    @test labels(sdm) == labels(nsdm)
    @test features(sdm) == features(nsdm)
end

@testitem "We can write a model and load it back" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(PCATransform, BIOCLIM, X, y)
    variables!(sdm, [1, 2, 12])
    train!(sdm)
    tf = tempname()
    writesdm(tf, sdm)
    nsdm = loadsdm(tf; threshold = false)
    @test threshold(sdm) == threshold(nsdm)
    @test variables(sdm) == variables(nsdm)
    @test labels(sdm) == labels(nsdm)
    @test features(sdm) == features(nsdm)
end

@testitem "We can write a Logistic model and load it back" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(ZScore, Logistic, X, y)
    variables!(sdm, [1, 2, 12])
    train!(sdm)
    tf = tempname()
    writesdm(tf, sdm)
    nsdm = loadsdm(tf; threshold = false)
    @test threshold(sdm) == threshold(nsdm)
    @test variables(sdm) == variables(nsdm)
    @test labels(sdm) == labels(nsdm)
    @test features(sdm) == features(nsdm)
end

@testitem "We can preserve the hyper-parameters when loading a model" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(ZScore, Logistic, X, y)
    variables!(sdm, [1, 2, 12])
    hyperparameters!(classifier(sdm), :epochs, 100)
    hyperparameters!(classifier(sdm), :interactions, :self)
    hyperparameters!(classifier(sdm), :η, 1e-5)
    hyperparameters!(classifier(sdm), :verbose, false)
    train!(sdm)
    tf = tempname()
    writesdm(tf, sdm)
    nsdm = loadsdm(tf; threshold = false)
    for hp in hyperparameters(typeof(classifier(sdm)))
        @test hyperparameters(classifier(sdm), hp) == hyperparameters(classifier(nsdm), hp)
    end
    @test threshold(sdm) == threshold(nsdm)
    @test variables(sdm) == variables(nsdm)
    @test labels(sdm) == labels(nsdm)
    @test features(sdm) == features(nsdm)
end