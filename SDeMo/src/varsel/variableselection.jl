function noselection!(model, folds; verbose::Bool = false, kwargs...)
    model.v = collect(axes(model.X, 1))
    train!(model; kwargs...)
    return model
end

function backwardselection!(model, folds; verbose::Bool = false, optimality=mcc, kwargs...)
    pool = collect(axes(model.X, 1))
    best_perf = -Inf
    while ~isempty(pool)
        if verbose
            @info "N = $(length(pool))"
        end
        scores = zeros(length(pool))
        for i in eachindex(pool)
            this_pool = deleteat!(copy(pool), i)
            model.v = this_pool
            scores[i] = mean(
                optimality.(
                    first(
                        crossvalidate(model, folds; kwargs...),
                    )
                ),
            )
        end
        best, i = findmax(scores)
        if best > best_perf
            best_perf = best
            deleteat!(pool, i)
        else
            if verbose
                @info "Returning with $(pool) -- $(best_perf)"
            end
            break
        end
    end
    model.v = pool
    train!(model; kwargs...)
    return model
end

function constrainedselection!(model, folds, pool; verbose::Bool = false, optimality=mcc, kwargs...)
    on_top = filter(p -> !(p in pool), collect(axes(X, 1)))
    best_perf = -Inf
    while ~isempty(on_top)
        if verbose
            @info "N = $(length(pool)+1)"
        end
        scores = zeros(length(on_top))
        for i in eachindex(on_top)
            this_pool = push!(copy(pool), on_top[i])
            model.v = this_pool
            scores[i] = mean(
                optimality.(
                    first(
                        crossvalidate(model, folds; kwargs...),
                    )
                ),
            )
        end
        best, i = findmax(scores)
        if best > best_perf
            best_perf = best
            push!(pool, on_top[i])
            deleteat!(on_top, i)
        else
            if verbose
                @info "Returning with $(pool) -- $(best_perf)"
            end
            break
        end
    end
    model.v = pool
    train!(model; kwargs...)
    return model
end

function forwardselection!(model, folds; kwargs...)
    pool = Int64[]
    return constrainedselection!(model, folds, pool; kwargs...)
end