"""
    Conformal

This objects wraps values for conformal prediction. It has a risk level α, and a
threshold for the positive and negative classes, resp. q₊ and q₋. In the case of
regular CP, the two thresholds are the same. For Mondrian CP, they are
different.

This type has a trained flag and therefore supports the `istrained` function. If
the prediction is attempted with a model that has not been trained, it should
result in an `UntrainedModelError`.
"""
Base.@kwdef mutable struct Conformal{T}
    α::T = 0.05
    q₊::T = zero(T)
    q₋::T = zero(T)
    trained::Bool = false
end

"""
    Conformal(α::AbstractFloat)

Creates an empty conformal predictor with a given risk level.
"""
function Conformal(α::T) where {T <: AbstractFloat}
    @assert zero(T) <= α <= one(T)
    return Conformal{T}(; α = α)
end

"""
    risklevel(cp::Conformal)

Returns the risk level of the conformal predictor.
"""
risklevel(cp::Conformal) = cp.α

"""
    risklevel!(cp::Conformal, α::T) where {T <: AbstractFloat}

Changes the risk level of the conformal predictor. It will need to be recalibrated.
"""
function risklevel!(cp::Conformal, α::T) where {T <: AbstractFloat}
    cp.α = α
    cp.trained = false
    return cp
end

"""
    istrained(cp::Conformal)

Returns `true` if the conformal predictor is ready to be used. This is used to
throw an `UntrainedModelError` otherwise.
"""
istrained(cp::Conformal) = cp.trained

function _conformal_score_from_model(model, training, calibration; kwargs...)
    # We will retrain the model so it needs to go into a copy
    𝐂 = copy(model)
    train!(𝐂; training = training, kwargs...)

    # Scoring function applied to the classes
    scoring = (p) -> [p, 1.0 - p]

    # Now we need to get the predictions
    f̂ = predict(𝐂; threshold = false)[calibration]

    # The scores for the calibration instances are
    s = scoring.(f̂)

    # We will now accumulate the scores in two different arrays -- this is
    # because it helps with Mondrian CP if we want to go this route
    s₊ = zeros(sum(labels(𝐂)[calibration]))
    s₋ = zeros(sum(.!labels(𝐂)[calibration]))

    # We also get a counter for each class
    c₊ = 0
    c₋ = 0

    # And now we loop, and assign the correct conformity score
    for i in eachindex(calibration)
        c = 1 - (labels(𝐂)[calibration][i] ? s[i][1] : s[i][2])
        if labels(𝐂)[calibration][i]
            c₊ += 1
            s₊[c₊] = c
        else
            c₋ += 1
            s₋[c₋] = c
        end
    end

    # When this is done, we return a tuple with the scores for presences and absences
    return (s₊, s₋)
end

function _q_from_conformal_scores(scores, risk_level)
    n = length(scores)
    cutoff = clamp(ceil((n + 1) * (1 - risk_level)) / n, 0.0, 1.0)
    return quantile(scores, cutoff)
end

function _ensure_conformal_is_trained(cp::Conformal)
    if !istrained(cp)
        throw(UntrainedModelError())
    end
    return nothing
end


"""
    train!(::Conformal, ::AbstractSDM, training, calibration; mondrian=true, kwargs...)

This trains a conformal predictor from a model, using a specified training and
calibration set, given as vectors of integers.

When using the `mondrian=true` keyword, the cutoffs are calculated for each
class separately.

All other `kwargs` are passed on to the model for training.
"""
function train!(
    cp::Conformal,
    model::T,
    training::Vector{Int},
    calibration::Vector{Int};
    mondrian::Bool = true,
    kwargs...,
) where {T <: AbstractSDM}
    s₊, s₋ = _conformal_score_from_model(model, training, calibration; kwargs...)

    if mondrian
        cp.q₊ = _q_from_conformal_scores(s₊, risklevel(cp))
        cp.q₋ = _q_from_conformal_scores(s₋, risklevel(cp))
    else
        s = vcat(s₊, s₋)
        q = _q_from_conformal_scores(s, risklevel(cp))
        cp.q₊ = q
        cp.q₋ = q
    end

    # The conformal is now trained
    cp.trained = true
    return cp
end


"""
    StatsAPI.predict(cp::Conformal, ŷ::Number)

Makes a prediction using a conformal predictor, for a given quantitative
prediction. The result is a set that contains boolean values (or is empty).
"""
function StatsAPI.predict(cp::Conformal, ŷ::Number)
    _ensure_conformal_is_trained(cp)

    # Scoring function
    scoring = (p) -> [p, 1.0 - p]

    # Scores
    p₊, p₋ = 1.0 .- scoring(ŷ)

    # And now get the the prediction set
    ℂ = Set()
    if p₊ <= cp.q₊
        push!(ℂ, true)
    end
    if p₋ <= cp.q₋
        push!(ℂ, false)
    end
    return ℂ
end

"""
    StatsAPI.predict(cp::Conformal, ŷ::Vector{T}) where {T <: Number}

Makes a prediction for a conformal prediction, for a vector of quantitative
predictions. Returns the output as a vector of sets.
"""
StatsAPI.predict(cp::Conformal, ŷ::Vector{T}) where {T <: Number} =
    map(y -> StatsAPI.predict(cp, y), ŷ)

"""
    train!(::Conformal, ::AbstractSDM, folds; kwargs...)

Trains a conformal predictor by taking the median cutoffs obtained across
different folds.
"""
function train!(
    cp::Conformal,
    model::S,
    folds::Vector{Tuple{Vector{Int}, Vector{Int}}};
    kwargs...,
) where {S <: AbstractSDM}
    cps = [Conformal(risklevel(cp)) for _ in eachindex(folds)]
    for i in eachindex(cps)
        train!(cps[i], model, folds[i]...; kwargs...)
    end
    cp.trained = true
    cp.q₊ = median([c.q₊ for c in cps])
    cp.q₋ = median([c.q₋ for c in cps])
    return cp
end

"""
    train!(cp::Conformal, model::S; kwargs...) where {S <: AbstractSDM}

Trains a conformal predictor by taking the median over k-fold sets.
"""
function train!(cp::Conformal, model::S; kwargs...) where {S <: AbstractSDM}
    train!(cp, model, kfold(model); kwargs...)
    return cp
end

@testitem "We can train a Mondrian conformal predictor" begin
    model = SDM(ZScore, Logistic, SDeMo.__demodata()...)
    cp = Conformal(0.05)
    train!(model)
    train!(cp, model, holdout(model)...; threshold = false, mondrian = true)
    @test istrained(cp)
    @test !iszero(cp.q₊)
    @test !iszero(cp.q₋)
end

@testitem "We can train a conformal predictor" begin
    model = SDM(ZScore, Logistic, SDeMo.__demodata()...)
    cp = Conformal(0.05)
    train!(model)
    train!(cp, model, holdout(model)...; threshold = false, mondrian = false)
    @test istrained(cp)
    @test !iszero(cp.q₊)
    @test !iszero(cp.q₋)
end

@testitem "We can predict with a trained conformal predictor" begin
    model = SDM(ZScore, Logistic, SDeMo.__demodata()...)
    cp = Conformal(0.05)
    train!(model)
    train!(cp, model, holdout(model)...; threshold = false)
    outcomes = predict(cp, predict(model; threshold = false))
    @test outcomes isa Vector{<:Set}
end

@testitem "We cannot predict with an untrained conformal predictor" begin
    model = SDM(ZScore, Logistic, SDeMo.__demodata()...)
    cp = Conformal(0.05)
    train!(model)
    @test_throws UntrainedModelError predict(cp, 0.5)
end

@testitem "We can train a model using folds" begin
    model = SDM(ZScore, Logistic, SDeMo.__demodata()...)
    cp = Conformal(0.05)
    train!(model)
    train!(cp, model, kfold(model))
    outcomes = predict(cp, predict(model; threshold = false))
    @test outcomes isa Vector{<:Set}
end

@testitem "We can train a model using folds with a keyword argument" begin
    model = SDM(ZScore, Logistic, SDeMo.__demodata()...)
    cp = Conformal(0.05)
    train!(model)
    train!(cp, model, kfold(model); mondrian=false)
    outcomes = predict(cp, predict(model; threshold = false))
    @test outcomes isa Vector{<:Set}
end

@testitem "We can train a model using folds without specifying them" begin
    model = SDM(ZScore, Logistic, SDeMo.__demodata()...)
    cp = Conformal(0.05)
    train!(model)
    train!(cp, model)
    outcomes = predict(cp, predict(model; threshold = false))
    @test outcomes isa Vector{<:Set}
end

@testitem "We can train a model using folds without specifying them but with a keyword argument" begin
    model = SDM(PCATransform, NaiveBayes, SDeMo.__demodata()...)
    variables!(model, ForwardSelection)
    cp = Conformal(0.05)
    train!(cp, model; mondrian = false)
    outcomes = predict(cp, predict(model; threshold = false))
    @test outcomes isa Vector{<:Set}
end