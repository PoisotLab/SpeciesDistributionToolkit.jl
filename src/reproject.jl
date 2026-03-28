function _projector(source, target)
    return SimpleSDMLayers.Proj.Transformation(
        source,
        target;
        always_xy = true,
    )
end

"""
    reproject(pol::SimpleSDMPolygons.FeatureCollection, dest)

Converts the points in a polygon to a different CRS, defined by its WKT.
"""
function reproject(fc::SimpleSDMPolygons.FeatureCollection, dest)
    reprojected_features = [Feature(reproject(ft, dest), ft.properties) for ft in fc.features]
    return FeatureCollection(reprojected_features)
end

function reproject(ft::SimpleSDMPolygons.Feature, dest)
    source = SimpleSDMPolygons.GI.crs(ft).val
    return SpeciesDistributionToolkit._reproject(_projector(source, dest), ft.geometry)
end

function reproject(mp::SimpleSDMPolygons.MultiPolygon, dest)
    source = SimpleSDMPolygons.GI.crs(mp).val
    return SpeciesDistributionToolkit._reproject(_projector(source, dest), mp)
end

function reproject(p::SimpleSDMPolygons.Polygon, dest)
    source = SimpleSDMPolygons.GI.crs(p).val
    return SpeciesDistributionToolkit._reproject(_projector(source, dest), p)
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