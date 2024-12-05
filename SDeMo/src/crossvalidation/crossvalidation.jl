"""
    leaveoneout(y, X)

Returns the splits for leave-one-out cross-validation. Each sample is used once,
on its own, for validation.

This method returns a vector of tuples, with each entry have the training data
first, and the validation data second.
"""
function leaveoneout(y, X)
    @assert size(y, 1) == size(X, 2)
    positions = collect(axes(X, 2))
    return [(setdiff(positions, i), i) for i in positions]
end

@testitem "We can do LOO validation" begin
    X, y = SDeMo.__demodata()
    model = SDM(MultivariateTransform{PCA}, NaiveBayes, X, y)
    folds = leaveoneout(model)
    cv = crossvalidate(model, folds)
    @test eltype(cv.validation) <: ConfusionMatrix
end

__classsplit(y) = findall(y), findall(!, y)

function __validation_idx(idx, p::T) where {T <: AbstractFloat}
    return idx[1:round(Int, p*length(idx))]
end

function __validation_idx(idx, k::Int)
    start_stop = unique(round.(Int, LinRange(1, length(idx), k + 1)))
    folds = Vector{eltype(idx)}[]
    for (i, stop) in enumerate(start_stop)
        if stop > 1
            start = start_stop[i - 1]
            if start > 1
                start += 1
            end
            push!(folds, idx[start:stop])
        end
    end
    return folds
end

"""
    holdout(y, X; proportion = 0.2, permute = true)

Sets aside a proportion (given by the `proportion` keyword, defaults to `0.2`)
of observations to use for validation, and the rest for training. An additional
argument `permute` (defaults to `true`) can be used to shuffle the order of
observations before they are split.

This method returns a single tuple with the training data first and the
validation data second. To use this with `crossvalidate`, it must be put in
`[]`.
"""
function holdout(y, X; proportion = 0.2, permute = true)
    @assert size(y, 1) == size(X, 2)
    # Split in positive/negative cases
    pos, neg = __classsplit(y)
    if permute
        Random.shuffle!(pos)
        Random.shuffle!(neg)
    end
    positions = collect(axes(X, 2))
    # Create the dataset
    holdout_instances = vcat(__validation_idx(pos, proportion), __validation_idx(neg, proportion))
    data_instances = setdiff(positions, holdout_instances)
    return (data_instances, holdout_instances)
end

@testitem "We can do holdout validation" begin
    X, y = SDeMo.__demodata()
    model = SDM(MultivariateTransform{PCA}, NaiveBayes, X, y)
    folds = holdout(model)
    cv = crossvalidate(model, [folds])
    @test eltype(cv.validation) <: ConfusionMatrix
end

"""
    montecarlo(y, X; n = 100, kwargs...)

Returns `n` (def. `100`) samples of `holdout`. Other keyword arguments are
passed to `holdout`.

This method returns a vector of tuples, with each entry have the training data
first, and the validation data second.
"""
function montecarlo(y, X; n = 100, kwargs...)
    @assert size(y, 1) == size(X, 2)
    return [holdout(y, X; kwargs...) for _ in 1:n]
end

@testitem "We can do montecarlo validation" begin
    X, y = SDeMo.__demodata()
    model = SDM(MultivariateTransform{PCA}, NaiveBayes, X, y)
    folds = montecarlo(model; n = 10)
    cv = crossvalidate(model, folds)
    @test eltype(cv.validation) <: ConfusionMatrix
    @test length(cv.training) == 10
end

"""
    kfold(y, X; k = 10, permute = true)

Returns splits of the data in which 1 group is used for validation, and `k`-1
groups are used for training. All `k`` groups have the (approximate) same size,
and each instance is only used once for validation (and `k`-1 times for
training). The groups are stratified (so that they have the same prevalence).

This method returns a vector of tuples, with each entry have the training data
first, and the validation data second.
"""
function kfold(y, X; k = 10, permute = true)
    @assert size(y, 1) == size(X, 2)
    # Split in positive/negative cases
    pos, neg = __classsplit(y)
    if permute
        Random.shuffle!(pos)
        Random.shuffle!(neg)
    end
    # List of instances positions
    positions = collect(axes(X, 2))
    # Validation data for pos/neg
    val = __validation_idx(pos, k) .∪ __validation_idx(neg, k)
    trn = [setdiff(positions, v) for v in val]
    return collect(zip(trn, val))
end

@testitem "We can do kfold validation" begin
    X, y = SDeMo.__demodata()
    model = SDM(MultivariateTransform{PCA}, NaiveBayes, X, y)
    folds = kfold(model; k = 12)
    cv = crossvalidate(model, folds)
    @test eltype(cv.validation) <: ConfusionMatrix
    @test length(cv.training) == 12
end

for op in (:leaveoneout, :holdout, :montecarlo, :kfold)
    eval(
        quote
            """
                $($op)(sdm::SDM)

            Version of `$($op)` using the instances and labels of an SDM.
            """
            $op(sdm::SDM, args...; kwargs...) =
                $op(labels(sdm), features(sdm), args...; kwargs...)
            """
                $($op)(sdm::Bagging)

            Version of `$($op)` using the instances and labels of a bagged SDM. In this case, the instances of the model used as a reference to build the bagged model are used.
            """
            $op(sdm::Bagging, args...; kwargs...) = $op(sdm.model, args...; kwargs...)
        end,
    )
end

@testitem "We can split data in an SDM" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(MultivariateTransform{PCA}(), BIOCLIM(), 0.01, X, y, 1:size(X, 1))
    folds = montecarlo(sdm; n = 10)
    @test length(folds) == 10
end

"""
    crossvalidate(sdm, folds; thr = nothing, kwargs...)

Performs cross-validation on a model, given a vector of tuples representing the
data splits. The threshold can be fixed through the `thr` keyword arguments. All
other keywords are passed to the `train!` method.

This method returns two vectors of `ConfusionMatrix`, with the confusion matrix
for each set of validation data first, and the confusion matrix for the training
data second.
"""
function crossvalidate(sdm::T, folds; thr = nothing, kwargs...) where {T <: AbstractSDM}
    Cv = zeros(ConfusionMatrix, length(folds))
    Ct = zeros(ConfusionMatrix, length(folds))
    models = [deepcopy(sdm) for _ in Base.OneTo(Threads.nthreads())]
    Threads.@threads for i in eachindex(folds)
        trn, val = folds[i]
        train!(models[Threads.threadid()]; training = trn, kwargs...)
        pred = predict(models[Threads.threadid()], features(sdm)[:, val]; threshold = false)
        ontrn =
            predict(models[Threads.threadid()], features(sdm)[:, trn]; threshold = false)
        thr = isnothing(thr) ? threshold(sdm) : thr
        Cv[i] = ConfusionMatrix(pred, labels(sdm)[val], thr)
        Ct[i] = ConfusionMatrix(ontrn, labels(sdm)[trn], thr)
    end
    return (validation = Cv, training = Ct)
end

@testitem "We can cross-validate an SDM" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(MultivariateTransform{PCA}(), BIOCLIM(), 0.5, X, y, [1, 2, 12])
    train!(sdm)
    cv = crossvalidate(sdm, kfold(sdm; k = 15))
    @test eltype(cv.validation) <: ConfusionMatrix
    @test eltype(cv.training) <: ConfusionMatrix
end

@testitem "We can cross-validate an ensemble model using the consensus keyword" begin
    using Statistics
    X, y = SDeMo.__demodata()
    sdm = SDM(MultivariateTransform{PCA}(), NaiveBayes(), 0.5, X, y, [1, 2, 12])
    ens = Bagging(sdm, 10)
    train!(ens)
    cv = crossvalidate(ens, kfold(ens; k = 15); consensus = median)
    @test eltype(cv.validation) <: ConfusionMatrix
    @test eltype(cv.training) <: ConfusionMatrix
end
