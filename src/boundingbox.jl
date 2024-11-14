"""
    boundingbox()

Returns a tuple with coordinates left, right, bottom, top in WGS84, which can be
used to decide which part of a raster should be loaded.
"""
boundingbox() = nothing

_padbbox(l, r, b, t, p) = (left=l-p, right=r+p, bottom=b-p, top=t+p)

"""
    boundingbox(occ::AbstractOccurrenceCollection; padding=0.0)

Returns the bounding box for a collection of occurrences, with an additional
padding.
"""
function boundingbox(occ::AbstractOccurrenceCollection; padding=0.0)
    left, right = extrema(longitudes(occ)) .+ (padding, -padding)
    bottom, top = extrema(latitudes(occ)) .+ (padding, -padding)
    return _padbbox(left, right, bottom, top, padding)
end

"""
    boundingbox(layer::SDMLayer; padding=0.0)

Returns the bounding box for a layer, with an additional padding.
"""
function boundingbox(layer::SDMLayer; padding=0.0)
    EL = eastings(layer)
    NL = northings(layer)
    prj = SimpleSDMLayers.Proj.Transformation(layer.crs, "+proj=longlat +datum=WGS84 +no_defs"; always_xy = true)

    b1 = [prj(EL[1], n) for n in NL]
    b2 = [prj(EL[end], n) for n in NL]
    b3 = [prj(e, NL[1]) for e in EL]
    b4 = [prj(e, NL[end]) for e in EL]
    bands = vcat(b1, b2, b3, b4)

    left, right = extrema(first.(bands)) .+ (padding, -padding)
    bottom, top = extrema(last.(bands)) .+ (padding, -padding)

    return _padbbox(left, right, bottom, top, padding)
end
