
function reproject(pol::SimpleSDMPolygons.AbstractGeometry, dest)
    source_wkt = SimpleSDMPolygons.GI.crs(pol).val
    target_wkt = dest
    xytrans = SimpleSDMLayers.Proj.Transformation(
        source_wkt,
        target_wkt;
        always_xy = true,
    )

    return SpeciesDistributionToolkit._reproject(xytrans, pol[1].geometry)
end

function reproject(occ::AbstractOccurrenceCollection, dest)
    source_wkt = "+proj=longlat +datum=WGS84 +no_defs"
    target_wkt = dest
    xytrans = SimpleSDMLayers.Proj.Transformation(
        source_wkt,
        target_wkt;
        always_xy = true,
    )

    return xytrans.(place(occ))
end
function reproject(sdm::AbstractSDM, dest)
    source_wkt = "+proj=longlat +datum=WGS84 +no_defs"
    if isgeoreferenced(sdm)
        target_wkt = dest
        xytrans = SimpleSDMLayers.Proj.Transformation(
            source_wkt,
            target_wkt;
            always_xy = true,
        )

        return xytrans.(sdm.coordinates)
    end
end