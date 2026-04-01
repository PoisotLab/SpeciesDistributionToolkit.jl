
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