function Base.show(io::IO, ensemble::Bagging)
    strs = [
        "{$(ensemble.model)} × $(length(ensemble.models))",
    ]
    return print(io, join(strs, "\n"))
end

function Base.show(io::IO, sdm::SDM)
    strs = [
        "$(typeof(sdm.transformer))",
        "$(typeof(sdm.classifier))",
        "P(x) ≥ $(round(sdm.threshold.cutoff; digits=3))",
    ]
    return print(io, join(strs, " → "))
end

function Base.show(io::IO, C::ConfusionMatrix)
    str = "[TP: $(C.tp), TN $(C.tn), FP $(C.fp), FN $(C.fn)]"
    return print(io, str)
end
