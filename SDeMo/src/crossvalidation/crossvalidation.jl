function threshold!(sdm, folds; endpoints=LinRange(0.0, 1.0, 50), optimality=mcc, kwargs...)
    C = hcat([first(crossvalidate(sdm, folds; τ=τ, threshold=false, kwargs...)) for τ in endpoints]...)
    model.τ = T[last(findmax(vec(mean(optimality.(C); dims=1))))]
    return C
end

function crossvalidate(sdm, folds; τ=nothing, kwargs...)
    Cv = zeros(ConfusionMatrix, length(folds))
    Ct = zeros(ConfusionMatrix, length(folds))
    models = [deepcopy(sdm) for _ in Base.OneTo(Threads.nthreads())]
    Threads.@threads for i in eachindex(folds)
        trn, val = folds[i]
        train!(models[Threads.threadid()]; training=trn, kwargs...)
        pred = predict(models[Threads.threadid()], X[:, val]; threshold = false)
        ontrn = predict(models[Threads.threadid()], X[:, trn]; threshold = false)
        thr = isnothing(τ) ? sdm.τ : τ
        Cv[i] = ConfusionMatrix(pred, y[val], thr)
        Ct[i] = ConfusionMatrix(ontrn, y[trn], thr)
    end
    return Cv, Ct
end

function leaveoneout(y, X)
    @assert size(y, 1) == size(X, 2)
    positions = collect(axes(X, 2))
    return [(setdiff(positions, i), i) for i in positions]
end

function holdout(y, X; proportion = 0.2, permute = true)
    @assert size(y, 1) == size(X, 2)
    sample_size = size(X, 2)
    n_holdout = round(Int, proportion * sample_size)
    positions = collect(axes(X, 2))
    if permute
        Random.shuffle!(positions)
    end
    data_pos = positions[1:(sample_size - n_holdout - 1)]
    hold_pos = positions[(sample_size - n_holdout):sample_size]
    return (data_pos, hold_pos)
end

function montecarlo(y, X; n = 100, kwargs...)
    @assert size(y, 1) == size(X, 2)
    return [holdout(y, X; kwargs...) for _ in 1:n]
end

function kfold(y, X; k = 10, permute = true)
    @assert size(y, 1) == size(X, 2)
    sample_size = size(X, 2)
    @assert k <= sample_size
    positions = collect(axes(X, 2))
    if permute
        Random.shuffle!(positions)
    end
    folds = []
    fold_ends = unique(round.(Int, LinRange(1, sample_size, k + 1)))
    for (i, stop) in enumerate(fold_ends)
        if stop > 1
            start = fold_ends[i - 1]
            if start > 1
                start += 1
            end
            hold_pos = positions[start:stop]
            data_pos = filter(p -> !(p in hold_pos), positions)
            push!(folds, (data_pos, hold_pos))
        end
    end
    return folds
end