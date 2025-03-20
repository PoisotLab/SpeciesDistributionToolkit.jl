"""
    RawData

A transformer that does *nothing* to the data. This is passing the raw data to
the classifier, and can be a good first step for models that assume that the
features are independent, or are not sensitive to the scale of the features.
"""
struct RawData <: Transformer end

train!(::RawData, args...) = nothing
StatsAPI.predict(::RawData, X) = X

@testitem "We can train a raw data transformer" begin
    X, y = SDeMo.__demodata()
    rd = RawData()
    train!(rd, X)
    px = predict(rd, X)
    for c in rand(CartesianIndices(X), 10)
        @test X[c] == px[c]
    end
end

"""
    ZScore

A transformer that scales and centers the data, using only the data that are
avaiable to the model at training time.

For all variables in the SDM features (regardless of whether they are used),
this transformer will store the observed mean and standard deviation. There is
no correction on the sample size, because there is no reason to expect that the
sample size will be the same for the training and prediction situation.
"""
Base.@kwdef mutable struct ZScore <: Transformer
    μ::AbstractArray = zeros(1)
    σ::AbstractArray = zeros(1)
end

function train!(zs::ZScore, X; kwdef...)
    zs.μ = vec(mean(X; dims = 2))
    zs.σ = vec(std(X; dims = 2))
    return zs
end
function StatsAPI.predict(zs::ZScore, x::AbstractArray)
    return (x .- zs.μ) ./ (zs.σ)
end

@testitem "We can train a z-score transformer" begin
    using SDeMo.Statistics
    X, y = SDeMo.__demodata()
    zs = ZScore()
    train!(zs, X)
    @test length(zs.μ) == size(X, 1)
    @test length(zs.σ) == size(X, 1)
    px = predict(zs, X)
    for m in mean(px; dims = 2)
        @test m ≈ 0 atol = 1e-6
    end
    for s in std(px; dims = 2)
        @test s ≈ 1 atol = 1e-6
    end
end
