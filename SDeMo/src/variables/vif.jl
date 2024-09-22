vif(m) = 1 / (1 - r²(m))

stepwisevif!(model::SDM, limit; kwargs...) = stepwisevif!(model, variables(model), limit)

function stepwisevif!(model::SDM, limit; kwargs...)
    Xv = features(model)[variables(model), :]
    X = (Xv .- mean(Xv; dims = 2)) ./ std(Xv; dims = 2)
    vifs = zeros(Float64, length(model.v))
    for i in eachindex(model.v)
        linreg = GLM.lm(X[setdiff(eachindex(model.v), i), :]', X[i, :])
        vifs[i] = vif(linreg)
    end
    if all(vifs .<= threshold)
        train!(model; kwargs...)
        return model
    end
    drop = last(findmax(vifs))
    popat!(variables(model), drop)
    return stepwisevif!(model, limit; kwargs...)
end