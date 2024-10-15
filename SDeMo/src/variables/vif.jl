demean = (x) -> (x .- mean(x; dims = 2))

"""
    vif(::Matrix)

Returns the variance inflation factor for each variable in a matrix, as the diagonal of the inverse of the correlation matrix between predictors.
"""
vif(X::Matrix{T}) where {T <: Number} = diag(inv(cor(X)))

"""
    vif(::AbstractSDM, tr=:)

Returns the VIF for the variables used in a SDM, optionally restricting to some training instances (defaults to `:` for all points). The VIF is calculated on the de-meaned predictors.
"""
vif(sdm::T, tr = :) where {T <: AbstractSDM} =
    vif(permutedims(demean(features(sdm)[variables(sdm),:])))

"""
    stepwisevif!(model::SDM, limit, tr=:;kwargs...)

Drops the variables with the largest variance inflation from the model, until all VIFs are under the threshold. The last positional argument (defaults to `:`) is the indices to use for the VIF calculation. All keyword arguments are passed to `train!`.
"""
function stepwisevif!(model::SDM, limit, tr = :; kwargs...)
    vifs = vif(model, tr)
    if all(vifs .<= limit)
        train!(model; kwargs...)
        return model
    end
    drop = last(findmax(vifs))
    popat!(variables(model), drop)
    return stepwisevif!(model, limit, tr; kwargs...)
end

@testitem "We can select variables using the VIF" begin
    X, y = SDeMo.__demodata()
    model = SDM(RawData, NaiveBayes, X, y)
    stepwisevif!(model, 10.0)
    @test length(variables(model)) < size(X, 1)
end
