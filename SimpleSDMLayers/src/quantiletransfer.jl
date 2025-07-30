"""
    quantiletransfer!(target::SDMLayer{T}, reference::SDMLayer) where {T <: Real}

Replaces the values in the `target` layer so that they follow the distribution
of the values in the `reference` layer. This works by (i) identifying the
quantile of each cell in the target layer, then (ii) replacing this with the
value for the same quantile in the reference layer.
"""
function quantiletransfer!(target::SDMLayer{T}, reference::SDMLayer{T}) where {T <: Real}
    Qt = quantize(target)
    target.grid = quantile(reference, Qt.grid)
    return target
end

"""
    quantiletransfer(target, reference)

Non-mutating version of `quantiletransfer!`
"""
function quantiletransfer(target::SDMLayer{T}, reference::SDMLayer{T}) where {T <: Real}
    t = deepcopy(target)
    quantiletransfer!(t, reference)
    return t
end