abstract type VariableSelectionStrategy end

struct ForwardSelection <: VariableSelectionStrategy end
struct BackwardSelection <: VariableSelectionStrategy end
struct VarianceInflationFactor <: VariableSelectionStrategy end
struct AllVariables <: VariableSelectionStrategy end

function _next_round(::Type{ForwardSelection}, current, future, included, forbidden)
    initial_set = included ∪ current
    return unique([[initial_set..., f] for f in setdiff(future, forbidden)])
end

function _next_round(::Type{BackwardSelection}, current, future, included, forbidden)
    return [setdiff(current, i) ∪ included for i in current]
end

function variables!(model::SDM, ::Type{T}, pool) where {T <: VariableSelectionStrategy}
    baseline = mcc(noskill(model))
    # TODO current, future, included, forbidden (is this the right typology?)
    future, included, forbidden = _makepools(T, model)
    # TODO while the baseline increases
    while true
        newbest = -Inf
        if newbest < baseline
            # TODO reset to past current
            break
        end 
    end
    # TODO while not enpty future
    # TODO train!
    # TODO return
end