"""
    _parse_projection_from_string(p::String)

This function will return the ArchGDAL SRS from a string. The three options are
an EPSG (or ESRI) string, a PROJ4 string, or the WKT itself.
"""
function _parse_projection_from_string(p::String)
    if startswith(p, "EPSG:")
        epsg_code = parse(Int, replace(p, "EPSG:" => ""))
        return AG.importEPSG(epsg_code)
    end
    if startswith(p, "ESRI:")
        epsg_code = parse(Int, replace(p, "ESRI:" => ""))
        return AG.importEPSG(epsg_code)
    end
    if startswith(p, "+proj")
        return AG.importPROJ4(p)
    end
    return AG.importWKT(p)
end

@testitem "We can get the SRS from a string" begin
    from_epsg = SimpleSDMLayers._parse_projection_from_string("EPSG:4326")
    from_proj =
        SimpleSDMLayers._parse_projection_from_string("+proj=longlat +datum=WGS84 +no_defs +type=crs")
    from_wkt = SimpleSDMLayers._parse_projection_from_string(
        """
GEOGCS["WGS 84",DATUM["WGS_1984",SPHEROID["WGS 84",6378137,298.257223563,AUTHORITY["EPSG","7030"]],AUTHORITY["EPSG","6326"]],PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.0174532925199433,AUTHORITY["EPSG","9122"]],AUTHORITY["EPSG","4326"]]
""",
    )
    from_esri_wkt = SimpleSDMLayers._parse_projection_from_string(
        """
GEOGCS["GCS_WGS_1984",DATUM["D_WGS_1984",SPHEROID["WGS_1984",6378137.0,298.257223563]],PRIMEM["Greenwich",0.0],UNIT["Degree",0.0174532925199433]]
""",
    )
    @test SimpleSDMLayers.AG.toPROJ4(from_epsg) == SimpleSDMLayers.AG.toPROJ4(from_proj)
    @test SimpleSDMLayers.AG.toPROJ4(from_epsg) == SimpleSDMLayers.AG.toPROJ4(from_wkt)
    @test SimpleSDMLayers.AG.toPROJ4(from_epsg) == SimpleSDMLayers.AG.toPROJ4(from_esri_wkt)
end

"""
    projection(layer::SDMLayer)

Returns the ArchGDAL SRS for a given layer.
"""
projection(layer::SDMLayer) = SimpleSDMLayers._parse_projection_from_string(layer.crs)
