_rescale(x, m, M) = (x .- minimum(x))./(maximum(x)-minimum(x)).*(M-m).+m

"""
    rescale!(layer::TI, template::TJ) where {TI <: SimpleSDMLayer, TJ <: SimpleSDMLayer}

Changes the values of the layer given as its first argument, so that it has the
same *range* as the values of the layer given as its second argument.
Modification is done in-place.
"""
function rescale!(layer::TI, template::TJ) where {TI <: SimpleSDMLayer, TJ <: SimpleSDMLayer}
    return rescale!(layer, extrema(template))
end

"""
    rescale!(layer::TI, t::Tuple{T,T}) where {TI <: SimpleSDMLayer, T <: Number}

Changes the values of the layer given as its first argument, so that it has the
same *range* as the values given as a tuple of values. Modification is done
in-place.
"""
function rescale!(layer::TI, t::Tuple{T,T}) where {TI <: SimpleSDMLayer, T <: Number}
    occ = findall(!isnothing, layer.grid)
    layer.grid[isnothing] .= _rescale(layer.grid[isnothing], t...)
end

"""
    rescale(layer::TI, template::TJ) where {TI <: SimpleSDMLayer, TJ <: SimpleSDMLayer}

Copying version of `rescale!`.
"""
function rescale(layer::TI, template::TJ) where {TI <: SimpleSDMLayer, TJ <: SimpleSDMLayer}
    l = copy(layer)
    return rescale!(l, extrema(template))
end

"""
    rescale(layer::TI, t::Tuple{T,T}) where {TI <: SimpleSDMLayer, T <: Number}

Copying version of `rescale!`.
"""
function rescale(layer::TI, t::Tuple{T,T}) where {TI <: SimpleSDMLayer, T <: Number}
    l = copy(layer)
    return rescale!(l, t)
end