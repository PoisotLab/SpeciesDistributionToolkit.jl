
"""
    variableimportance(model, folds, variable; reps=10, optimality=mcc, kwargs...)

Returns the importance of one variable in the model. The `samples` keyword fixes
the number of bootstraps to run (defaults to `10`, which is not enough!).

The keywords are passed to `ConfusionMatrix`.
"""
function variableimportance(model::T, folds, variable; samples=10, optimality=mcc, kwargs...) where {T <: AbstractSDM}
    O = zeros(length(folds), samples)
    for (i, fold) in enumerate(folds)
        cm = deepcopy(model)
        train!(cm; training=fold[2])
        X = copy(features(model)[:, fold[1]])
        orig = ConfusionMatrix(predict(cm, X; kwargs...), labels(model)[fold[1]])
        for rep in Base.OneTo(samples)
            perm = ConfusionMatrix(predict(cm, _permute_at(X, variable); kwargs...), labels(model)[fold[1]])
            O[i,rep] = abs(optimality(orig) - optimality(perm))
        end
    end
    return mean(O)
end

function _permute_at(X, i)
    Xp = copy(X)
    Xp[i,:] = shuffle(X[i,:])
    return Xp
end

"""
    variableimportance(model, folds; kwargs...)

Returns the importance of all variables in the model. The keywords are passed to
`variableimportance`.
"""
variableimportance(model, folds; kwargs...) = [variableimportance(model, folds, v; kwargs...) for v in variables(model)]