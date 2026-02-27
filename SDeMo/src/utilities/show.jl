function Base.show(io::IO, ensemble::Bagging)
    model_info = _showstring_sdm(ensemble.model, false)
    str_show = "{$(model_info)} × $(length(ensemble.models))"
    return print(io, str_show)
end

function Base.show(io::IO, ensemble::Ensemble)
    strs = ["\t $(m)" for m in ensemble.models]
    pushfirst!(strs, "An ensemble model with:")
    return print(io, join(strs, "\n"))
end

function Base.show(io::IO, b::AdaBoost)
    model_info = _showstring_sdm(b.model, false)
    str_show = "AdaBoost {$(model_info)} × $(b.iterations) iterations"
    return print(io, str_show)
end

function _showstring_sdm(sdm, full)
    _tr_string = istrained(sdm) ? "☑️ " : "❎ "
    _gr_string = isgeoreferenced(sdm) ? "" : "🗺️ "
    strs = [
        "$(typeof(sdm.transformer))",
        "$(typeof(sdm.classifier))",
        "P(x) ≥ $(round(sdm.τ; digits=3))",
    ]
    str_show = full ? join([_tr_string; join(strs, " → "); _gr_string], " ") : join(strs, " → ")
    return str_show
end

Base.show(io::IO, sdm::SDM) = print(io, _showstring_sdm(sdm, true))

function Base.show(io::IO, c::ConfusionMatrix)
    print(io, "(tp: $(c.tp), fp: $(c.fp); fn: $(c.fn), tn: $(c.tn))")
end