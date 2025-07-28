"""
    quantiletransfer!(target::SDMLayer{T}, reference::SDMLayer; n::Int=10) where {T <: Real}

Replaces the values in the `target` layer so that they follow the distribution
of the values in the `reference` layer. This works by (i) identifying the
quantile of each cell in the target layer, then (ii) replacing this with the
value for the same quantile in the reference layer.
"""
function quantiletransfer!(target::SDMLayer{T}, reference::SDMLayer; n::Int=10) where {T <: Real}
    Qt = quantize(target, round(Int, n * sqrt(count(reference))))
    target.grid = quantile(reference, Qt.grid)
    return target
end

"""
    quantiletransfer(target, reference)

Non-mutating version of `quantiletransfer!`
"""
function quantiletransfer(target, reference)
    t = deepcopy(target)
    quantiletransfer!(t, reference)
    return t
end