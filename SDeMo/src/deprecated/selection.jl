function noselection!(model, folds; kwargs...)
    @warn "noselection! will be deprecated - use variables! with AllVariables instead"
    return noselection!(model, kwargs...)
end

function noselection!(model; verbose::Bool = false, kwargs...)
    @warn "noselection! will be deprecated - use variables! with AllVariables instead"
    model.v = collect(axes(model.X, 1))
    train!(model; kwargs...)
    return model
end

function backwardselection!(
    model,
    folds,
    pool;
    verbose::Bool = false,
    optimality = mcc,
    kwargs...,
)
    @warn "backwardselection! will be deprecated - use variables! with BackwardSelection instead"
    candidates = filter(p -> !(p in pool), variables(model))
    best_perf = mcc(noskill(model))
    while ~isempty(candidates)
        if verbose
            nvar = lpad(length(candidates), 2, " ")
            @info "[$(nvar) vars.] MCC val. ≈ $(round(best_perf; digits=3))"
        end
        scores = zeros(length(candidates))
        for i in eachindex(candidates)
            proposal = deleteat!(copy(candidates), i)
            variables!(model, vcat(pool, proposal))
            scores[i] = optimality(crossvalidate(model, folds).validation)
        end
        best, i = findmax(scores)
        if best > best_perf
            best_perf = best
            deleteat!(candidates, i)
        else
            break
        end
    end
    variables!(model, vcat(pool, candidates))
    if verbose
        @info "Optimal var. pool: $(variables(model))"
    end
    train!(model; kwargs...)
    return model
end

function forwardselection!(
    model,
    folds,
    pool;
    verbose::Bool = false,
    optimality = mcc,
    kwargs...,
)
    @warn "forwardselection! will be deprecated - use variables! with ForwardSelection instead"
    on_top = filter(p -> !(p in pool), variables(model))
    best_perf = mcc(noskill(model))
    while ~isempty(on_top)
        if verbose
            nvar = lpad(length(pool), 2, " ")
            @info "[$(nvar) vars.] MCC val. ≈ $(round(best_perf; digits=3))"
        end
        scores = zeros(length(on_top))
        for i in eachindex(on_top)
            this_pool = push!(copy(pool), on_top[i])
            variables!(model, this_pool)
            scores[i] = optimality(crossvalidate(model, folds; kwargs...).validation)
        end
        best, i = findmax(scores)
        if best > best_perf
            best_perf = best
            push!(pool, on_top[i])
            deleteat!(on_top, i)
        else
            break
        end
    end
    variables!(model, pool)
    if verbose
        @info "Optimal var. pool: $(variables(model))"
    end
    train!(model; kwargs...)
    return model
end

function forwardselection!(model, folds; kwargs...)
    pool = Int64[]
    return forwardselection!(model, folds, pool; kwargs...)
end

function backwardselection!(model, folds; kwargs...)
    pool = Int64[]
    return backwardselection!(model, folds, pool; kwargs...)
end

@testitem "We can do forward selection with no included features" tags=[:deprecated] begin
    X, y, C = SDeMo.__demodata()
    model = SDM(MultivariateTransform{PCA}, NaiveBayes, X, y)
    folds = [holdout(model)]
    forwardselection!(model, folds)
    @test length(variables(model)) < size(X, 1)
end

@testitem "We can do forward selection with included features" tags=[:deprecated] begin
    X, y, C = SDeMo.__demodata()
    model = SDM(MultivariateTransform{PCA}, NaiveBayes, X, y)
    folds = [holdout(model)]
    forwardselection!(model, folds, [1,12]; verbose=true)
    @test length(variables(model)) < size(X, 1)
    @test 1 in variables(model)
    @test 12 in variables(model)
end

@testitem "We can do backward selection with no included features" tags=[:deprecated] begin
    X, y, C = SDeMo.__demodata()
    model = SDM(MultivariateTransform{PCA}, NaiveBayes, X, y)
    folds = [holdout(model)]
    backwardselection!(model, folds)
    @test length(variables(model)) < size(X, 1)
end

@testitem "We can do backward selection with included features" tags=[:deprecated] begin
    X, y, C = SDeMo.__demodata()
    model = SDM(MultivariateTransform{PCA}, NaiveBayes, X, y)
    folds = [holdout(model)]
    backwardselection!(model, folds, [1,12])
    @test length(variables(model)) < size(X, 1)
    @test 1 in variables(model)
    @test 12 in variables(model)
end

@testitem "We can do verbose forward selection" tags=[:deprecated] begin
    X, y, C = SDeMo.__demodata()
    model = SDM(MultivariateTransform{PCA}, NaiveBayes, X, y)
    folds = [holdout(model)]
    forwardselection!(model, folds; verbose=true)
    @test length(variables(model)) < size(X, 1)
end

@testitem "We can do verbose backward selection" tags=[:deprecated] begin
    X, y, C = SDeMo.__demodata()
    model = SDM(MultivariateTransform{PCA}, NaiveBayes, X, y)
    folds = [holdout(model)]
    backwardselection!(model, folds; verbose=true)
    @test length(variables(model)) < size(X, 1)
end

@testitem "Variable selection does not reset the model" tags=[:deprecated] begin
    X, y, C = SDeMo.__demodata()
    model = SDM(MultivariateTransform{PCA}, NaiveBayes, X, y)
    folds = [holdout(model)]
    pool = [1,2,3,4,5,6,7,8,9]
    variables!(model, pool)
    backwardselection!(model, folds; verbose=true)
    for v in variables(model)
        @test v in pool
    end
    @test length(variables(model)) <= length(pool)
end

@testitem "Variable selection with non-model variables forced works" tags=[:deprecated] begin
    X, y, C = SDeMo.__demodata()
    model = SDM(MultivariateTransform{PCA}, NaiveBayes, X, y)
    folds = [holdout(model)]
    pool = [1,2,3,4,5,6,7,8,9]
    forced = [12,13]
    variables!(model, pool)
    forwardselection!(model, folds, forced; verbose=true)
    for v in variables(model)
        if !(v in forced)
            @test v in pool
        end
    end
    for f in forced
        @test f in variables(model)
    end
end


@testitem "Variable selection methods can be chained" tags=[:deprecated] begin
    X, y, C = SDeMo.__demodata()
    model = SDM(MultivariateTransform{PCA}, NaiveBayes, X, y)
    n0 = length(variables(model))
    stepwisevif!(model, 50.0)
    n1 = length(variables(model))
    @test n1 <= n0
    folds = [holdout(model)]
    forwardselection!(model, folds; verbose=true)
    n2 = length(variables(model))
    @test n2 <= n1
end
