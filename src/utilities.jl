"""
    gainloss(contemporary::SDMLayer{Bool}, future::SDMLayer{Bool})

Returns a layer with values -1, 0, and 1 corresponding to the difference in
ranges.
"""
function gainloss(contemporary::SDMLayer{Bool}, future::SDMLayer{Bool})
    rangemask = nodata((contemporary)|(future), false)
    return mask(Int8.(contemporary) - Int8.(future), rangemask)
end


