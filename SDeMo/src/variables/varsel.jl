abstract type VariableSelectionStrategy end

struct ForwardSelection <: VariableSelectionStrategy end
#struct BackwardSelection <: VariableSelectionStrategy end
#struct VarianceInflationFactor <: VariableSelectionStrategy end
#struct AllVariables <: VariableSelectionStrategy end

function _next_round(::Type{ForwardSelection}, current, forced, possible)
    initial_set = current ∪ forced
    includable = setdiff(possible, initial_set)
    combinations = unique([[initial_set..., p] for p in includable])
    return combinations
end

function _initial_proposal(::Type{ForwardSelection}, model)
    return []
end

function variables!(model::SDM, ::Type{T}, pool, folds; kwargs...) where {T <: VariableSelectionStrategy}
    baseline = mcc(noskill(model))
    checkpoint = _initial_proposal(T, model) # This is the initial pool we work with
    possible = copy(variables(model))
    while true
        combination_todo = _next_round(T, checkpoint, pool, possible)
        scores = zeros(length(combination_todo))
        for (i, combination) in enumerate(combination_todo)
            variables!(model, combination)
            C = crossvalidate(model, folds)
            scores[i] = mcc(C.validation)
        end
        newbest = maximum(scores)
        if newbest <= baseline
            variables!(model, checkpoint)
            break
        else
            variables!(model, combination_todo[last(findmax(scores))])
            checkpoint = copy(variables(model))
            baseline = newbest
        end
    end
    train!(model; kwargs...)
    return model
end
