struct Catalog
    url::String
    id::String
    title::String
    description::String
    version::VersionNumber
    extensions::Vector{String}
end

function Catalog(url)
    req = HTTP.get(url)
    output = __handle_get_response(req)
    return Catalog(
        url,
        get(output, "id", ""),
        get(output, "title", ""),
        get(output, "description", ""),
        VersionNumber(output["stac_version"]),
        get(output, "extensions", String[]),
    )
end

@testitem "We can get the GEOBON STAC landing page" begin
    geobon = STACApi.Catalog("https://stac.geobon.org/")
    @test geobon.title == "BON in a Box STAC"
    @test geobon.id == "geobon-stac"
end

Base.show(io::IO, catalog::STACApi.Catalog) = print(io, "📚 $(catalog.id) @ $(catalog.url)")