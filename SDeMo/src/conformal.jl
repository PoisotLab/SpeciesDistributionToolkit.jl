"""
    Conformal

This objects wraps values for conformal prediction. It has a risk level α, and a
threshold for the positive and negative classes, resp. q₊ and q₋. In the case of
regular CP, the two thresholds are the same. For Mondrian CP, they are
different.

This type has a trained flag and supports the `istrained` function.
"""
Base.@kwdef struct Conformal{T} where {T <: AbstractFloat}
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
    return Conformal(; α = α)
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
    𝐂 = deepcopy(model)
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

StatsAPI.predict(cp::Conformal, ŷ::Vector{T}) where {T <: Number} = map(y -> StatsAPI.predict(cp, y), ŷ)

function train!(
    cp::Conformal,
    model::T,
    training,
    calibration;
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

    cp.trained = true

    return cp
end

#=
TODO: port this too
function conformal(cp::C, model::S, folds::Vector{Tuple{Vector{Int}, Vector{Int}}}; kwargs...) where {C <: AbstractConformal, S <: AbstractSDM}
    mc_q = [conformal(cp, model, f...; kwargs...) for f in folds]
    return Tuple(vec(median(vcat([hcat(q...) for q in mc_q]...), dims=1)))
end

function conformal(cp::C, model::S; kwargs...) where {C <: AbstractConformal, S <: AbstractSDM}
    return conformal(cp, model, kfold(model); kwargs...)
end
=#
