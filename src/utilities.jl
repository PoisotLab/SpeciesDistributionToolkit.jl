import Base: clamp, clamp!

"""
    gainloss(contemporary::SDMLayer{Bool}, future::SDMLayer{Bool})

Returns a layer with values -1, 0, and 1 corresponding to the difference in
ranges. The two layers given as input must be layers with boolean values where
`true` indicates that the pixel is in the range. The presence of `false` pixels
is irrelevant as these are ignored internally.
"""
function gainloss(contemporary::SDMLayer{Bool}, future::SDMLayer{Bool})
    rangemask = nodata((contemporary) | (future), false)
    return mask(Int8.(contemporary) - Int8.(future), rangemask)
end

function discretize(layer, n::Integer)
    categories = rescale(layer, 0.0, 1.0)
    map!(x -> round(x * (n - 1); digits = 0) / (n - 1), categories.grid, categories.grid)
    map!(x -> x * (n - 1) + 1, categories.grid, categories.grid)
    map!(x -> isnan(x) ? zero(eltype(categories.grid)) : x, categories.grid)
    return convert(SDMLayer{Int}, categories)
end

function Base.clamp!(layer::SDMLayer{T}, lo::L, hi::H) where {T <: Number, L <: Number, H <: Number}
    clamp!(layer.grid, lo, hi)
    return layer
end

function Base.clamp(layer::SDMLayer{T}, lo::L, hi::H) where {T <: Number, L <: Number, H <: Number}
    cp = copy(layer)
    clamp!(cp, lo, hi)
    return cp
end

"""
    reconcile!(L::Vector{<:SDMLayer})

Takes a stack of layers, and ensure that they have the same `x` and `y` values.
This should be used as a last resort when some data providers have layers that
don't fully align after clipping.
"""
function reconcile!(L::Vector{<:SDMLayer})
    try
        SimpleSDMLayers._layers_are_compatible(L)
    catch err
        if err isa DifferentNorthSouthExtentError
            nc = StatsBase.countmap([l.y for l in L])
            key = collect(keys(nc))[last(findmax(collect(values(nc))))]
            for i in eachindex(L)
                L[i].y = key
            end
        elseif err isa DifferentEastWestExtentError
            nc = StatsBase.countmap([l.x for l in L])
            key = collect(keys(nc))[last(findmax(collect(values(nc))))]
            for i in eachindex(L)
                L[i].x = key
            end
        else
            throw(err)
        end
    else
        return L
    end
end


"""
    reconcile(L::Vector{<:SDMLayer})

Non-mutating version of `reconcile!`.
"""
function reconcile(L::Vector{<:SDMLayer})
    C = [copy(l) for l in L]
    reconcile!(C)
    return C
end