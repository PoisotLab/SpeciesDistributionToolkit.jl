
"""
    variableimportance(model, folds, variable; reps=10, optimality=mcc, kwargs...)

Returns the importance of one variable in the model. The `reps` keyword fixes
the number of bootstraps to run (defaults to `10`, which is not enough!).

The keywords are passed to `ConfusionMatrix`.
"""
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
    return mean(O)
end

function varimp_shuffle(model, fold, var; kwargs...)
    X = copy(model.X[:, fold[1]])
    orig = ConfusionMatrix(predict(model, X; kwargs...), model.y[fold[1]])
    X[var,:] =  shuffle(X[var,:])
    perm = ConfusionMatrix(predict(model, X; kwargs...), model.y[fold[1]])
    return (orig, perm)
end

"""
    variableimportance(model, folds; kwargs...)

Returns the importance of all variables in the model. The keywords are passed to
`variableimportance`.
"""
variableimportance(model, folds; kwargs...) = [variableimportance(model, folds, v; kwargs...) for v in variables(model)]