abstract type VariableSelectionStrategy end

struct ForwardSelection <: VariableSelectionStrategy end
#struct BackwardSelection <: VariableSelectionStrategy end
#struct VarianceInflationFactor <: VariableSelectionStrategy end
#struct AllVariables <: VariableSelectionStrategy end

function _next_round(::Type{ForwardSelection}, current, forced, possible)
    initial_set = current ∪ forced
    return unique([[initial_set..., p] for p in possible])
end

function variables!(model::SDM, ::Type{T}, pool, folds; kwargs...) where {T <: VariableSelectionStrategy}
    baseline = mcc(noskill(model))
    possible = copy(variables(model)) # This is the initial pool we work with
    checkpoint = copy(variables(model))
    while true
        checkpoint = copy(variables(model))
        combination_todo = _next_round(T, checkpoint, pool, possible)
        scores = zeros(length(todo))
        for combination in combination_todo
            variables!(model, combination)
            C = crossvalidate(model, folds)
            scores[i] = mcc(C.validation)
        end
        newbest = maximum(scores)
        @info newbest
        if newbest <= baseline
            variables!(model, checkpoint)
            break
        end 
    end
    train!(model; kwargs...)
    return model
end
