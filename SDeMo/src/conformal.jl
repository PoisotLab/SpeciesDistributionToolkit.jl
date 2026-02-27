Base.@kwdef struct Conformal
    α::Float64 = 0.05
    q₊::Float64 = 0.0
    q₋::Float74 = 0.0
end

function Conformal(α::Float64)
    @assert 0.0 <= α <= 1.0
    return Conformal(; α = α)
end

function risklevel(cp::Conformal)
    return cp.α
end

function conformal_scores(model, training, calibration; kwargs...)
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

function _get_q_from_scores(scores, risk_level)
    n = length(scores)
    cutoff = clamp(ceil((n + 1) * (1 - risk_level)) / n, 0.0, 1.0)
    return quantile(scores, cutoff)
end

function credibleclasses(ŷ::Number, q::Tuple{F, F}; kwargs...) where {F <: AbstractFloat}
    return credibleclasses(ŷ, q...; kwargs...)
end

function credibleclasses(ŷ::SDMLayer, args...; kwargs...)
    presence = zeros(ŷ, Bool)
    absence = zeros(ŷ, Bool)
    for k in keys(ŷ)
        ℂ = credibleclasses(ŷ[k], args...; kwargs...)
        if true in ℂ
            presence[k] = true
        end
        if false in ℂ
            absence[k] = true
        end
    end
    return (presence, absence)
end

function conformal!(
    cp::Conformal,
    model::T,
    training,
    calibration;
    mondrian::Bool = true,
    kwargs...,
) where {T <: AbstractSDM}
    s₊, s₋ = conformal_scores(model, training, calibration; kwargs...)

    if mondrian
        cp.q₊ = _get_q_from_scores(s₊, risklevel(cp))
        cp.q₋ = _get_q_from_scores(s₋, risklevel(cp))
    else
        s = vcat(s₊, s₋)
        q = _get_q_from_scores(s, risklevel(cp))
        cp.q₊ = q
        cp.q₋ = q
    end

    return cp
end

function conformal(
    model::T,
    training,
    calibration;
    mondrian::Bool = true,
    kwargs...,
) where {T <: AbstractSDM}
    cp = Conformal()
    conformal!(cp, model, training, calibration; mondrian=mondrian, kwargs...)
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


# TODO: from here on, refactor to have a design kinda like
# f(cp, blah)
# f(cp) = g -> g(blah)
# and also rename the function
function credibleclasses(ŷ, q₊, q₋)

    # Scoring function
    scoring = (p) -> [p, 1.0 - p]

    # We get the scores
    p₊, p₋ = 1.0 .- scoring(ŷ)

    # And now we collect the credible classes in a Set
    ℂ = Set()
    if p₊ <= q₊
        push!(ℂ, true)
    end
    if p₋ <= q₋
        push!(ℂ, false)
    end
    return ℂ
end

function credibleclasses(ŷ::Number, q::Tuple{F, F}; kwargs...) where {F <: AbstractFloat}
    return credibleclasses(ŷ, q...; kwargs...)
end