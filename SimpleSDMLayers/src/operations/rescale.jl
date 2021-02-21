_rescale(x, m, M) = (x .- minimum(x))./(maximum(x)-minimum(x)).*(M-m).+m

"""
    rescale!()

TODO
"""
function rescale!(layer::TI, template::TJ) where {TI <: SimpleSDMLayer, TJ <: SimpleSDMLayer}
    return rescale!(layer, extrema(template))
end

function rescale!(layer::TI, t::Tuple{T,T}) where {TI <: SimpleSDMLayer, T <: Number}
    occ = findall(!isnothing, layer.grid)
    layer.grid[isnothing] .= _rescale(layer.grid[isnothing], t...)
end


function rescale(layer::TI, template::TJ) where {TI <: SimpleSDMLayer, TJ <: SimpleSDMLayer}
    l = copy(layer)
    return rescale!(l, extrema(template))
end

function rescale(layer::TI, t::Tuple{T,T}) where {TI <: SimpleSDMLayer, T <: Number}
    l = copy(layer)
    return rescale!(l, t)
end