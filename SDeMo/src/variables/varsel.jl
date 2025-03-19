abstract type VariableSelectionStrategy end

struct ForwardSelection <: VariableSelectionStrategy end
struct BackwardSelection <: VariableSelectionStrategy end
struct AllVariables <: VariableSelectionStrategy end
struct VarianceInflationFactor{N} <: VariableSelectionStrategy end

_demean = (x) -> (x .- mean(x; dims = 2))
_vif(X::Matrix{T}) where {T <: Number} = diag(inv(cor(X)))
_vif(sdm::T) where {T <: AbstractSDM} = _vif(permutedims(_demean(features(sdm))))

_next_round(::Type{AllVariables}, model, forced, possible) = [collect(axes(features(model), 1))]
_next_round(::Type{BackwardSelection}, model, forced, possible) = [setdiff(variables(model), i) for i in setdiff(variables(model), forced)]

function _next_round(::Type{ForwardSelection}, model, forced, possible)
    initial_set = variables(model) ∪ forced
    includable = setdiff(possible, initial_set)
    combinations = unique([unique([initial_set..., p]) for p in includable])
    return combinations
end

function _next_round(::Type{VarianceInflationFactor{N}}, model, forced, possible) where {N}
    vifs = _vif(model)
    # Artifically set the VIF of forced variables to 0 so they are always included
    for (i, v) in enumerate(variables(model))
        if v in forced
            vifs[i] = 0.0
        end
    end
    # Return the variable with the highest VIF if above the threshold
    v = variables(model)
    if maximum(vifs) >= N
        v = setdiff(v, last(findmax(vifs)))
    end
    return [v ∪ forced]
end

_initial_proposal(::Type{<:VariableSelectionStrategy}, model) = copy(variables(model))
_initial_proposal(::Type{ForwardSelection}, model) = Int[]

function variables!(model::SDM, ::Type{T}, pool::Vector{Int}, folds::Vector{Tuple{Vector{Int}, Vector{Int}}}; optimality=mcc, verbose::Bool=false, kwargs...) where {T <: VariableSelectionStrategy}
    baseline = optimality(noskill(model))
    possible = copy(variables(model))
    checkpoint = _initial_proposal(T, model)
    variables!(model, checkpoint)
    if verbose
        @info "Baseline $(optimality): $(baseline)"
    end
    while true
        combination_todo = _next_round(T, model, pool, possible)
        scores = zeros(length(combination_todo))
        for (i, combination) in enumerate(combination_todo)
            variables!(model, combination)
            C = crossvalidate(model, folds; kwargs...)
            scores[i] = optimality(C.validation)
        end
        newbest = maximum(scores)
        if newbest <= baseline
            if verbose
                @info "Returning model with $(length(variables(model))) variables - $(optimality) ≈ $(round(baseline; digits=4))"
            end
            variables!(model, checkpoint)
            break
        else
            variables!(model, combination_todo[last(findmax(scores))])
            if verbose
                @info "Optimal $(length(variables(model))) variables model - $(optimality) ≈ $(round(newbest; digits=4))"
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

@testitem "We can do variable selection with a different measure" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(ZScore, DecisionTree, X, y)
    variables!(sdm, ForwardSelection; optimality=κ, verbose=true)
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

@testitem "We can do VIF selection" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(ZScore, DecisionTree, X, y)
    f = kfold(sdm)
    variables!(sdm, VarianceInflationFactor{10.0}, [1,12], f)
    @test 1 in variables(sdm)
    @test 12 in variables(sdm)
    @test length(variables(sdm)) < 19
end