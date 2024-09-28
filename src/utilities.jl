"""
    gainloss(contemporary::SDMLayer{Bool}, future::SDMLayer{Bool})

Returns a layer with values -1, 0, and 1 corresponding to the difference in
ranges.
"""
function gainloss(contemporary::SDMLayer{Bool}, future::SDMLayer{Bool})
    rangemask = nodata((contemporary)|(future), false)
    return mask(Int8.(contemporary) - Int8.(future), rangemask)
end


"""
    discretize(layer, n::Integer)

Returns a rescaled layer (in [0,1]) where the values are rounded so that there
are `n` unique values. This is useful notably for bivariate maps and VSUPs.
"""
function discretize(layer, n::Integer)
    categories = rescale(layer, 0.0, 1.0)
    n = n - 2
    map!(x -> round(x * (n + 1); digits=0) / (n + 1), categories.grid, categories.grid)
    return n * categories
end

