function _projector(source, target)
    return SimpleSDMLayers.Proj.Transformation(
        source,
        target;
        always_xy = true,
    )
end

"""
    reproject(pol::SimpleSDMPolygons.AbstractGeometry, dest)

Converts the points in a polygon to a different CRS, defined by its WKT.
"""
function reproject(pol::SimpleSDMPolygons.AbstractGeometry, dest)
    source = SimpleSDMPolygons.GI.crs(pol).val
    target = dest
    return SpeciesDistributionToolkit._reproject(_projector(source, target), pol[1].geometry)
end

"""
    reproject(occ::AbstractOccurrenceCollection, dest)

Converts the points in an abstract occurrence collection to a different CRS,
defined by its WKT. Note that this only returns the coordinates, and not the
rest of the occurrence information.
"""
function reproject(occ::AbstractOccurrenceCollection, dest)
    source = "+proj=longlat +datum=WGS84 +no_defs"
    target = dest
    return _projector(source, target).(place(occ))
end

"""
    reproject(sdm::AbstractSDM, dest)

Converts the georeferences instances in an SDM to a different CRS, defined by
its WKT. Note that this only returns the coordinates, and not the rest of the
model.
"""
function reproject(sdm::AbstractSDM, dest)
    if isgeoreferenced(sdm)
        source = "+proj=longlat +datum=WGS84 +no_defs"
        target = dest
        return _projector(source, target).(sdm.coordinates)
    else
        error("This model has no georeferenced instances and cannot be projected")
    end
end