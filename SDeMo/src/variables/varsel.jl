"""
    VariableSelectionStrategy

This is an abstract type to which all variable selection types belong. The
variable selection methods should define a method for `variables!`, whose first
argument is a model, and the second argument is a selection strategy. The third
and fourth positional arguments are, respectively, a list of variables to be
included, and the folds to use for cross-validation. They can be omitted and
would default to no default variables, and k-fold cross-validation.
"""
abstract type VariableSelectionStrategy end

"""
    ForwardSelection

Variables are included one at a time until the performance of the models stops
improving.
"""
struct ForwardSelection <: VariableSelectionStrategy end

"""
    ForwardSelection

Variables are removed one at a time until the performance of the models stops
improving.
"""
struct BackwardSelection <: VariableSelectionStrategy end

"""
    AllVariables

All variables in the training dataset are used. Note that this also
crossvalidates and trains the model.
"""
struct AllVariables <: VariableSelectionStrategy end

"""
    VarianceInflationFactor{N}

Removes variables one at a time until the largest VIF is lower than `N` (a
floating point number), or the performancde of the model stops increasing. Note
that the resulting set of variables may have a largest VIF larger than the
threshold. See `StrictVarianceInflationFactor` for an alternative.
"""
struct VarianceInflationFactor{N} <: VariableSelectionStrategy end

"""
    StrictVarianceInflationFactor{N}

Removes variables one at a time until the largest VIF is lower than `N` (a
floating point number). By contrast with `VarianceInflationFactor`, this
approach to variable selection will *not* cross-validate the model, and might
result in a model that is far worse than any other variable selection technique.
"""
struct StrictVarianceInflationFactor{N} <: VariableSelectionStrategy end

_demean(x::Matrix{T}) where {T <: Number} = (x .- mean(x; dims = 2))
_vif(X::Matrix{T}) where {T <: Number} = diag(inv(cor(X)))
_vif(sdm::T) where {T <: AbstractSDM} =
    _vif(permutedims(_demean(features(sdm)[variables(sdm), :])))

_next_round(::Type{AllVariables}, model, forced, possible) =
    [collect(axes(features(model), 1))]
_next_round(::Type{BackwardSelection}, model, forced, possible) =
    [setdiff(variables(model), i) for i in setdiff(variables(model), forced)]

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

"""
    variables!(model::AbstractSDM, ::Type{T}, folds::Vector{Tuple{Vector{Int}, Vector{Int}}}; included=Int[], optimality=mcc, verbose::Bool=false, bagfeatures::Bool=false, kwargs...) where {T <: VariableSelectionStrategy}

Performs variable selection based on a selection strategy, with a possible
`folds` for cross-validation. If omitted, this defaults to k-folds.

The model is retrained on the optimal set of variables after training.

**Keywords**:

  - `included` (`Int[]`), a list of variables that must be included in the model
  - `optimality` (`mcc`), the measure to optimise at each round of variable
    selection
  - `verbose` (`false`), whether the performance should be returned after each
    round of variable selection
  - `bagfeatures` (`false`), whether `bagfeatures!` should be called on each model
    in an homogeneous ensemble
  - all other keywords are passed to `train!` and `crossvalidate`

**Important notes**:

 1. When using `bagfeatures` with a pool of included variables, they will always
    be present in the overall model, but not necessarilly in each model of the
    ensemble
 2. When using `VarianceInflationFactor`, the variable selection will stop even
    if the VIF is above the threshold, if it means producing a model with a lower
    performance -- using `variables!` will *always* lead to a better model
"""
function variables!(
    model::M,
    ::Type{T},
    folds::Vector{Tuple{Vector{Int}, Vector{Int}}};
    included::Vector{Int} = Int[],
    optimality = mcc,
    verbose::Bool = false,
    bagfeatures::Bool = false,
    kwargs...,
) where {T <: VariableSelectionStrategy, M <: Union{SDM, Bagging}}

    # If bagfeatures is called for a model where it doesn't apply, we raise a
    # warning, but keep working because this is a no-op.
    if bagfeatures
        if !(typeof(model) <: Bagging)
            @warn "The bagfeatures keyword is only used for Bagging models"
        end
    end

    # The possible variables we operate on are always the list of variables
    # currently used in the model, which allows chaining variable selection
    # steps together. This is at best a questionable idea, but it makes some
    # sense when doing VIF before iterative selection, for example.
    possible = copy(variables(model))

    # The checkpoint is a vector containing the list of variables to include in
    # the model at first. This is not a series of variables to test, but the
    # content of the model originally. Each VariableSelectionStrategy will have
    # its own initial proposal.
    checkpoint = _initial_proposal(T, model)

    # We then initialize the model with the variables that have been retained as
    # part of the initial proposal. The selection can start now.
    variables!(model, checkpoint)

    # The initial optimal score to beat will be different if the initial
    # proposal has variables in it or not. By default, we will pick the no-skill
    # classifier.
    baseline = optimality(noskill(model))

    # But if there are already variables in the model, then our baseline to beat
    # is the cross-validation on this initial situation. This is important when
    # chaining variable selection steps together, otherwise the first proposal
    # is unfairly evaluated.
    if ~isempty(variables(model))
        C = crossvalidate(model, folds; kwargs...)
        baseline = optimality(C.validation)
    end

    # In case of verbose output, we return the baseline performance.
    if verbose
        @info "Baseline $(optimality): $(baseline)"
    end

    # This little flag is here to let us know that we are still currently
    # looking for the optimal set of variables. As soon as we set it to false,
    # we will jump out of the loop.
    still_looking = true

    # This is the variable selection loop proper. Pay attention.
    while still_looking

        # We will overwrite the variables in this loop, so checkpoint.
        checkpoint = copy(variables(model))

        # The list of variables combinations to test is decided here. It is
        # determined based on three criteria: the model itself (to look at
        # already included variables), the list of variables forcibly included,
        # which are never dropped/not-considered, and the list of variables that
        # are eligible for inclusion.
        combination_todo = _next_round(T, model, included, possible)

        # If there are no combinations of variable to evaluate based on the
        # VariableSelectionStrategy, we want to break out of the loop!
        if isempty(combination_todo)
            stil_looking = false # This isn't particularly required but it's free. Good value.
            break
        end

        # Each combination of variables to consider will receive a score based
        # on the optimality measure, and for this reason we will initialize an
        # array of zeros, to store them. This array has one entry for each
        # variable combination.
        scores = zeros(length(combination_todo))

        # This loop will go through all of the the variables combinations, put
        # these variables as the current variables for the model, and then
        # cross-validate the proposal.
        for (i, combination) in enumerate(combination_todo)
            
            # This is where we temporarily replace the variables in the model by
            # the proposal.
            variables!(model, combination)

            # For bagged ensembles only, assuming we want to bag the features as
            # well (bagging features is great, you should def do it), it happens
            # here.
            if (typeof(model) <: Bagging) & bagfeatures
                bagfeatures!(model)
            end

            # This is just the cross-validation.
            C = crossvalidate(model, folds; kwargs...)

            # The score for each proposal is the optimality measure applied to
            # the validation sets (averaged).
            scores[i] = optimality(C.validation)
        end

        # OK wait. We have fucked up the model by putting different proposals
        # inside it when cross-validating. This was worth it because
        # over-writing models is good and training is cheap, but let's take a
        # moment to remember that the variables in the model may not be optimal
        # yet. So we restore the variables, just in case we have not found a
        # more optimal solution.
        variables!(model, checkpoint)

        # To know whether we have identified an optimal set of variables, we
        # look at the maximum value of the various proposals. To save some time,
        # we also extract the position matching the best set, as will save us a
        # step later on.
        newbest, bestset = findmax(scores)

        # The first situation is that none of the variables evaluated as part of
        # the previous round are better than what the model was before.
        if newbest <= baseline

            # If no variable combination results in an improvement, we know that
            # the previous model was the best under this variable selection
            # scheme, so we are done looking.
            still_looking = false

            # We can return this model - note that we have restored it to the
            # checkpoint before the proposals.
            if verbose
                @info "Returning model with $(length(variables(model))) variables - $(optimality) ≈ $(round(baseline; digits=4))"
            end

            # Again, we bag the features if required and the model is compatible
            # with this step.
            if (typeof(model) <: Bagging) & bagfeatures
                bagfeatures!(model)
            end
        else

            # This block is reached when there is a variable combination that
            # boosts the performance of the model.
            
            # The first thing we need to do is to assign this proposal as the
            # new set of variables for the model.
            variables!(model, combination_todo[bestset])

            # Again, bag features, etc etc
            if (typeof(model) <: Bagging) & bagfeatures
                bagfeatures!(model)
            end

            # Yap yap yap
            if verbose
                @info "Optimal $(length(variables(model))) variables model - $(optimality) ≈ $(round(newbest; digits=4))"
            end

            # Really important step here: the baseline has changed, as the model
            # is getting better.
            baseline = newbest
        end
    end

    # We finally re-train the model
    train!(model; kwargs...)
    
    # And return it - we're done with variable selection
    return model
end

function variables!(
    model::AbstractSDM,
    ::Type{T};
    kwargs...,
) where {T <: VariableSelectionStrategy}
    return variables!(model, T, kfold(model); kwargs...)
end

@testitem "We can do forward variable selection" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(ZScore, DecisionTree, X, y)
    f = kfold(sdm)
    variables!(sdm, ForwardSelection, f; included = [1, 12])
    @test 1 in variables(sdm)
    @test 12 in variables(sdm)
    @test length(variables(sdm)) < 19
end

@testitem "We can do backward variable selection" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(ZScore, DecisionTree, X, y)
    f = kfold(sdm)
    variables!(sdm, BackwardSelection, f; included = [1, 12])
    @test 1 in variables(sdm)
    @test 12 in variables(sdm)
    @test length(variables(sdm)) < 19
end

@testitem "The default folds are used in variable selection if not specified" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(ZScore, DecisionTree, X, y)
    f = kfold(sdm)
    variables!(sdm, ForwardSelection; included = [1, 12])
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
    variables!(sdm, ForwardSelection; optimality = κ)
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
    variables!(sdm, VarianceInflationFactor{10.0}, f; included = [1, 12])
    @test 1 in variables(sdm)
    @test 12 in variables(sdm)
    @test length(variables(sdm)) < 19
end

@testitem "We can do selection on a bagged ensemble" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(ZScore, DecisionTree, X, y)
    f = kfold(sdm)
    ensemble = Bagging(sdm, 10)
    variables!(ensemble, ForwardSelection, f; included = [1, 12])
    @test 1 in variables(sdm)
    @test 12 in variables(sdm)
    @test length(variables(sdm)) < 19
    for model in models(ensemble)
        @test 1 in variables(model)
        @test 12 in variables(model)
        @test length(variables(model)) == length(variables(ensemble))
    end
end

@testitem "We can do selection on a bagged ensemble with bagged features" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(ZScore, DecisionTree, X, y)
    f = kfold(sdm)
    ensemble = Bagging(sdm, 10)
    variables!(ensemble, ForwardSelection, f; bagfeatures = true, included = [1, 12])
    @test 1 in variables(sdm)
    @test 12 in variables(sdm)
    @test length(variables(sdm)) < 19
    for model in models(ensemble)
        @test length(variables(model)) < length(variables(ensemble))
    end
end

function _get_constrained_vifs(model, included)
    V = _vif(model)
    for (i, v) in enumerate(variables(model))
        if v in included
            V[i] = 0.0
        end
    end
    return V
end

"""
    variables!(model::M, ::Type{StrictVarianceInflationFactor{N}}, args...; included::Vector{Int}=Int[], optimality=mcc, verbose::Bool=false, bagfeatures::Bool=false, kwargs...) where {M <: Union{SDM, Bagging}, N}

Version of the variable selection for the strict VIF case. This may result in a
worse model, and for this reason there is no cross-validation.
"""
function variables!(
    model::M,
    ::Type{StrictVarianceInflationFactor{N}},
    args...;
    included::Vector{Int} = Int[],
    optimality = mcc,
    verbose::Bool = false,
    bagfeatures::Bool = false,
    kwargs...,
) where {M <: Union{SDM, Bagging}, N}
    V = _get_constrained_vifs(model, included)
    if verbose
        @info "Current max. VIF: $(maximum(V))"
    end
    while maximum(V) >= N
        v = setdiff(variables(model), variables(model)[last(findmax(V))])
        variables!(model, v)
        V = _get_constrained_vifs(model, included)
        if verbose
            @info "Current max. VIF: $(maximum(V))"
        end
    end
    if (typeof(model) <: Bagging) & bagfeatures
        bagfeatures!(model)
    end
    train!(model; kwargs...)
    return model
end

@testitem "We can do strict VIF selection" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(ZScore, DecisionTree, X, y)
    variables!(sdm, StrictVarianceInflationFactor{50.0}; included = [1, 12])
    @test 1 in variables(sdm)
    @test 12 in variables(sdm)
    @test length(variables(sdm)) < 19
end