function Base.show(io::IO, ensemble::Bagging)
    strs = [
        "{$(ensemble.model)} × $(length(ensemble.models))",
    ]
    return print(io, join(strs, "\n"))
end

function Base.show(io::IO, ensemble::Ensemble)
    strs = ["\t $(m)" for m in ensemble.models]
    pushfirst!(strs, "An ensemble model with:")
    return print(io, join(strs, "\n"))
end

function Base.show(io::IO, b::AdaBoost)
    strs = [
        "AdaBoost {$(b.model)} × $(b.iterations) iterations",
    ]
    return print(io, join(strs, "\n"))
end

function Base.show(io::IO, sdm::SDM)
    strs = [
        "$(typeof(sdm.transformer))",
        "$(typeof(sdm.classifier))",
        "P(x) ≥ $(round(sdm.τ; digits=3))",
    ]
    return print(io, join(strs, " → "))
end

function Base.show(io::IO, C::ConfusionMatrix)
    str = "[TP: $(C.tp), TN $(C.tn), FP $(C.fp), FN $(C.fn)]"
    return print(io, str)
end
