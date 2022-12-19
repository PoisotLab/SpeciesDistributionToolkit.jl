_rescale(x, m, M) = (x .- minimum(x)) ./ (maximum(x) - minimum(x)) .* (M - m) .+ m

"""
    rescale!(layer::TI, template::TJ) where {TI <: SimpleSDMLayer, TJ <: SimpleSDMLayer}

Changes the values of the layer given as its first argument, so that it has the
same *range* as the values of the layer given as its second argument.
Modification is done in-place.
"""
function rescale!(
    layer::TI,
    template::TJ,
) where {TI <: SimpleSDMLayer, TJ <: SimpleSDMLayer}
    return rescale!(layer, extrema(template))
end

"""
    rescale!(layer::TI, t::Tuple{T,T}) where {TI <: SimpleSDMLayer, T <: Number}

Changes the values of the layer given as its first argument, so that it has the
same *range* as the values given as a tuple of values. Modification is done
in-place.
"""
function rescale!(layer::TI, t::Tuple{T, T}) where {TI <: SimpleSDMLayer, T <: Number}
    occ = findall(!isnothing, layer.grid)
    return layer.grid[occ] .= _rescale(layer.grid[occ], t...)
end

"""
    rescale(layer::TI, template::TJ) where {TI <: SimpleSDMLayer, TJ <: SimpleSDMLayer}

Copying version of `rescale!`.
"""
function rescale(layer::TI, template::TJ) where {TI <: SimpleSDMLayer, TJ <: SimpleSDMLayer}
    l = copy(layer)
    return rescale!(l, extrema(template))
    return l
end

"""
    rescale(layer::TI, t::Tuple{T,T}) where {TI <: SimpleSDMLayer, T <: Number}

Copying version of `rescale!`.
"""
function rescale(layer::TI, t::Tuple{T, T}) where {TI <: SimpleSDMLayer, T <: Number}
    l = copy(layer)
    rescale!(l, t)
    return l
end

"""
    rescale!(layer::T, p::Vector{Real}) where {T <: SimpleSDMLayer}

Rescale the values of a `layer` so that they match with the quantiles given in
`p`. Internally, this uses the `Statistics.quantile` function.
"""
function rescale!(layer::T, p::Vector{TI}) where {T <: SimpleSDMLayer, TI <: AbstractFloat}
    q = reverse!(quantile(layer, p))
    occupied = findall(!isnothing, layer.grid)
    v = values(layer)
    for i in 1:length(q)
        layer.grid[occupied[findall(x -> x <= q[i], v)]] .= reverse(p)[i]
    end
    return layer
end

"""
    rescale(layer::T, p::Vector{Real}) where {T <: SimpleSDMLayer}

Copying version of `rescale!`.
"""
function rescale(layer::T, p::Vector{TI}) where {T <: SimpleSDMLayer, TI <: AbstractFloat}
    l = copy(layer)
    rescale!(l, p)
    return l
end

function rescale(layer::T, lr::LinRange) where {T <: SimpleSDMLayer}
    @assert 1.0 >= minimum(lr) >= 0.0
    @assert 1.0 >= maximum(lr) >= 0.0
    return rescale(layer, collect(lr))
end

function rescale!(layer::T, lr::LinRange) where {T <: SimpleSDMLayer}
    @assert 1.0 >= minimum(lr) >= 0.0
    @assert 1.0 >= maximum(lr) >= 0.0
    return rescale!(layer, collect(lr))
end

function rescale(layer::T, srl::StepRangeLen) where {T <: SimpleSDMLayer}
    @assert 1.0 >= minimum(srl) >= 0.0
    @assert 1.0 >= maximum(srl) >= 0.0
    return rescale(layer, collect(srl))
end

function rescale!(layer::T, srl::StepRangeLen) where {T <: SimpleSDMLayer}
    @assert 1.0 >= minimum(srl) >= 0.0
    @assert 1.0 >= maximum(srl) >= 0.0
    return rescale!(layer, collect(srl))
end