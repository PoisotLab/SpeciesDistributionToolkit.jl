"""
    leaveoneout(y, X)

Returns the splits for leave-one-out cross-validation. Each sample is used once,
on its own, for validation.

This method returns a vector of tuples, with each entry have the training data
first, and the validation data second.

The `rebalanced` keyword, defaults to `false`, drops a random point of the
opposite label as per `10.1126/sciadv.adx6976`.
"""
function leaveoneout(y, X; rebalanced::Bool = false)
    @assert size(y, 1) == size(X, 2)
    positions = collect(axes(X, 2))
    loosamples = [(setdiff(positions, i), i) for i in positions]

    # If we rebalance to avoid data leakage due to class balance information, this happens here
    if rebalanced

        # Within each sample...
        for S in loosamples

            # We figure out the label of the tested sample
            target_label = y[S[2]]

            # And then we pick a random training sample with the opposite label
            dropped_inverse_label = rand(findall(!=(target_label), S[1]))

            # And drop it
            deleteat!(S[1], dropped_inverse_label)
        end
    end

    # Now we return
    return loosamples
end

@testitem "We can do LOO validation" begin
    X, y = SDeMo.__demodata()
    model = SDM(MultivariateTransform{PCA}, NaiveBayes, X, y)
    folds = leaveoneout(model)
    cv = crossvalidate(model, folds)
    @test eltype(cv.validation) <: ConfusionMatrix
end

@testitem "We can do LOO validation with re-balancing" begin
    X, y = SDeMo.__demodata()
    model = SDM(MultivariateTransform{PCA}, NaiveBayes, X, y)
    folds = leaveoneout(model; rebalanced = true)
    @test length(folds[1][1]) == length(y) - 2
end

"""
    __classsplit(y)

Returns a tuple with the presences indices, and the absences indices - this is used to maintain class balance in cross-validation and bagging
"""
__classsplit(y) = findall(y), findall(!, y)

function __validation_idx(idx, p::T) where {T <: AbstractFloat}
    return idx[1:round(Int, p * length(idx))]
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
    holdout_instances =
        vcat(__validation_idx(pos, proportion), __validation_idx(neg, proportion))
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
groups are used for training. All `k`` groups have the (approximate) same size, and each instance is only used once for validation (and `k`-1 times for
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
    # We get the threshold to use for classification only once
    τ = isnothing(thr) ? threshold(sdm) : thr

    # Thread-safe structure
    chunk_size = max(1, length(folds) ÷ (5 * Threads.nthreads()))
    data_chunks = Base.Iterators.partition(folds, chunk_size)

    tasks = map(data_chunks) do chunk
        Threads.@spawn begin
            model = deepcopy(sdm)
            Cv = zeros(ConfusionMatrix, length(chunk))
            Ct = zeros(ConfusionMatrix, length(chunk))
            for i in eachindex(chunk)
                Cv[i], Ct[i] = SDeMo._validate_one_model!(model, chunk[i], τ, kwargs...)
            end
            return Cv, Ct
        end
    end

    confmats_batched = fetch.(tasks)
    return (
        validation = vcat(first.(confmats_batched)...),
        training = vcat(last.(confmats_batched)...),
    )
end

"""
    crossvalidate(sdm::T, args...; kwargs...) where {T <: AbstractSDM}

Performs cross-validation using 10-fold validation as a default. Called when
`crossvalidate` is used without a `folds` second argument.
"""
function crossvalidate(sdm::T, args...; kwargs...) where {T <: AbstractSDM}
    return crossvalidate(sdm, kfold(sdm; k = 10), args...; kwargs...)
end

"""
    threshold!(sdm::SDM, folds::Vector{Tuple{Vector{Int}, Vector{Int}}}; optimality=mcc)

Optimizes the threshold for a SDM using cross-validation, as given by the
`folds`. This is meant to be used _after_ cross-validation, as it will
cross-validate the threshold across all the training data in a way that is a
little more robust than the version in `train!`.

The specific technique used is to train one model per fold, then aggregate all
of their predictions on the validation data, and find the value of the threshold
that maximizes the average performance across folds.
"""
function threshold!(
    sdm::SDM,
    folds::Vector{Tuple{Vector{Int}, Vector{Int}}};
    optimality = mcc,
)
    p = predict(sdm; threshold = false)

    # We will save all the predictions in this object
    Y = Vector{typeof(p)}(undef, length(folds))

    # Thread-safe structure for the models
    chunk_size = max(1, length(folds) ÷ (5 * Threads.nthreads()))
    data_chunks = Base.Iterators.partition(eachindex(folds), chunk_size)

    tasks = map(data_chunks) do chunk
        Threads.@spawn begin
            model = deepcopy(sdm)
            for i in chunk
                train!(model; training = folds[i][1], threshold = false)
                Y[i] = predict(model; threshold = false)[folds[i][2]]
            end
            return Y[chunk]
        end
    end

    # We wait until it's done
    fetch.(tasks)

    # We now aggregate the values in Y
    y = extrema(vcat(Y...))
    thresholds = LinRange(y..., 100)
    opt = zeros(length(thresholds), length(folds))
    for i in eachindex(folds)
        for j in eachindex(thresholds)
            opt[j, i] =
                optimality(ConfusionMatrix(Y[i], labels(sdm)[folds[i][2]], thresholds[j]))
        end
    end

    # We measure teh MEAN performance across threshold values
    mean_opt = vec(mapslices(mean, opt; dims = 2))

    # And we apply the best threshold and return the model
    threshold!(sdm, thresholds[last(findmax(mean_opt))])
    return sdm
end

"""
    threshold!(sdm::SDM; kwargs...)

Version of `threshold!` without folds, for which the default of 10-fold
validation will be used.
"""
function threshold!(sdm::SDM; kwargs...)
    return threshold!(sdm, kfold(sdm; k = 10); kwargs...)
end

"""
    _validate_one_model!(model::AbstractSDM, fold, τ, kwargs...)

Trains the model and returns the Cv and Ct conf matr. Used internally by
cross-validation.
"""
function _validate_one_model!(model::T, fold, τ, kwargs...) where {T <: AbstractSDM}
    trn, val = fold
    train!(model; training = trn, kwargs...)
    pred = predict(model, features(model)[:, val]; threshold = false)
    ontrn = predict(model, features(model)[:, trn]; threshold = false)
    Cv = ConfusionMatrix(pred, labels(model)[val], τ)
    Ct = ConfusionMatrix(ontrn, labels(model)[trn], τ)
    return Cv, Ct
end

@testitem "We can cross-validate an SDM" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(PCATransform, BIOCLIM, X, y)
    variables!(sdm, [1, 2, 12])
    train!(sdm)
    folds = kfold(sdm; k = 15)
    cv = crossvalidate(sdm, folds)
    @test eltype(cv.validation) <: ConfusionMatrix
    @test eltype(cv.training) <: ConfusionMatrix
end

@testitem "We can cross-validate a model without specifying folds" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(PCATransform, BIOCLIM, X, y)
    variables!(sdm, [1, 2, 12])
    train!(sdm)
    cv = crossvalidate(sdm)
    @test eltype(cv.validation) <: ConfusionMatrix
    @test eltype(cv.training) <: ConfusionMatrix
end

@testitem "We can cross-validate an ensemble model using the consensus keyword" begin
    using Statistics
    X, y = SDeMo.__demodata()
    sdm = SDM(PCATransform, NaiveBayes, X, y)
    variables!(sdm, [1, 2, 12])
    ens = Bagging(sdm, 10)
    train!(ens)
    folds = kfold(sdm; k = 15)
    cv = crossvalidate(ens, folds; consensus = median)
    @test eltype(cv.validation) <: ConfusionMatrix
    @test eltype(cv.training) <: ConfusionMatrix
end
