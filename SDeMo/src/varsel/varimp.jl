function variableimportance(model, folds, variable; reps=10, optimality=mcc, kwargs...)
    O = zeros(length(folds), reps)
    for (i, fold) in enumerate(folds)
        cm = deepcopy(model)
        train!(cm; training=fold[2])
        for rep in 1:reps
            o, p = varimp_shuffle(cm, fold, variable; kwargs...)
            O[i,rep] = abs(optimality(o) - optimality(p))
        end
    end
    return O
end

function varimp_shuffle(model, fold, var; kwargs...)
    X = model.X[:, fold[1]]
    orig = ConfusionMatrix(predict(model, X; kwargs...), model.y[fold[1]])
    X[var,:] =  shuffle(X[var,:])
    perm = ConfusionMatrix(predict(model, X; kwargs...), model.y[fold[1]])
    return (orig, perm)
end