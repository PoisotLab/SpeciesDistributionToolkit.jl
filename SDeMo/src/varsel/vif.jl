using GLM

vif(m) = 1 / (1 - r²(m))

function stepwisevif!(model::SDM, threshold; kwargs...)
    return stepwisevif!(model, model.v, threshold)
end

function stepwisevif!(model::SDM, threshold; kwargs...)
    Xv = model.X[model.v,:]
    X = (Xv .- mean(Xv; dims = 2)) ./ std(Xv; dims = 2)
    vifs = zeros(Float64, length(model.v))
    for i in eachindex(model.v)
        linreg = GLM.lm(Xv[setdiff(eachindex(model.v), i), :]', Xv[i, :])
        vifs[i] = vif(linreg)
    end
    if all(vifs .<= threshold)
        train!(model; kwargs...)
        return model
    end
    drop = last(findmax(vifs))
    popat!(model.v, drop)
    #@info "Variables remaining: $(model.v)"
    return stepwisevif!(model, threshold; kwargs...)
end