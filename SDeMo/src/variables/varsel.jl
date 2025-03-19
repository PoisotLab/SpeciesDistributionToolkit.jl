abstract type VariableSelectionStrategy end

struct ForwardSelection <: VariableSelectionStrategy end
struct BackwardSelection <: VariableSelectionStrategy end
struct AllVariables <: VariableSelectionStrategy end
#struct VarianceInflationFactor <: VariableSelectionStrategy end

function _next_round(::Type{ForwardSelection}, current, forced, possible)
    initial_set = current ∪ forced
    includable = setdiff(possible, initial_set)
    combinations = unique([unique([initial_set..., p]) for p in includable])
    return combinations
end

_next_round(::Type{BackwardSelection}, current, forced, possible) = [setdiff(current, i) for i in setdiff(current, forced)]
_next_round(::Type{AllVariables}, current, forced, possible) = [current]

_initial_proposal(::Type{ForwardSelection}, model) = Int[]
_initial_proposal(::Type{BackwardSelection}, model) = copy(variables(model))
_initial_proposal(::Type{AllVariables}, model) = copy(variables(model))

function variables!(model::SDM, ::Type{T}, pool::Vector{Int}, folds::Vector{Tuple{Vector{Int}, Vector{Int}}}; verbose::Bool=false, kwargs...) where {T <: VariableSelectionStrategy}
    baseline = mcc(noskill(model))
    checkpoint = _initial_proposal(T, model) # This is the initial pool we work with
    possible = copy(variables(model))
    if verbose
        @info "Baseline MCC: $(baseline)"
    end
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
            if verbose
                @info "Returning model with $(length(variables(model))) variables - MCC ≈ $(round(baseline; digits=4))"
            end
            variables!(model, checkpoint)
            break
        else
            variables!(model, combination_todo[last(findmax(scores))])
            if verbose
                @info "Optimal $(length(variables(model))) variables model - MCC ≈ $(round(newbest; digits=4))"
            end
            checkpoint = copy(variables(model))
            baseline = newbest
        end
    end
    train!(model; kwargs...)
    return model
end

function variables!(model::SDM, ::Type{T}; kwargs...) where {T <: VariableSelectionStrategy}
    return variables!(model, T, Int[], kfold(model); kwargs...)
end

function variables!(model::SDM, ::Type{T}, pool::Vector{Int}; kwargs...) where {T <: VariableSelectionStrategy}
    return variables!(model, T, pool, kfold(model); kwargs...)
end

function variables!(model::SDM, ::Type{T}, folds::Vector{Tuple{Vector{Int}, Vector{Int}}}; kwargs...) where {T <: VariableSelectionStrategy}
    return variables!(model, T, Int[], folds; kwargs...)
end

@testitem "We can do forward variable selection" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(ZScore, DecisionTree, X, y)
    f = kfold(sdm)
    variables!(sdm, ForwardSelection, [1,12], f)
    @test 1 in variables(sdm)
    @test 12 in variables(sdm)
    @test length(variables(sdm)) < 19
end

@testitem "We can do backward variable selection" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(ZScore, DecisionTree, X, y)
    f = kfold(sdm)
    variables!(sdm, BackwardSelection, [1,12], f)
    @test 1 in variables(sdm)
    @test 12 in variables(sdm)
    @test length(variables(sdm)) < 19
end

@testitem "The default folds are used in variable selection if not specified" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(ZScore, DecisionTree, X, y)
    f = kfold(sdm)
    variables!(sdm, ForwardSelection, [1,12])
    @test 1 in variables(sdm)
    @test 12 in variables(sdm)
    @test length(variables(sdm)) < 19
end

@testitem "All variables are used if no pool is given" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(ZScore, DecisionTree, X, y)
    variables!(sdm, ForwardSelection, kfold(sdm))
    @test length(variables(sdm)) < 19
end

@testitem "We can do variable selection without any arguments" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(ZScore, DecisionTree, X, y)
    variables!(sdm, ForwardSelection)
    @test length(variables(sdm)) < 19
end

@testitem "We can reset variables" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(ZScore, DecisionTree, X, y)
    variables!(sdm, ForwardSelection)
    @test length(variables(sdm)) < 19
    variables!(sdm, AllVariables)
    @test length(variables(sdm)) == 19
end
