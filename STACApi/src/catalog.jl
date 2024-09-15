struct Catalog
    url::String
    title::String
    description::String
    version::VersionNumber
end

function Catalog(url)
    req = HTTP.get(url)
    output = __handle_get_response(req)
    return Catalog(
        url,
        output["title"],
        output["description"],
        VersionNumber(output["stac_version"])
    )
end

@testitem "We can get the GEOBON STAC landing page" begin
    geobon = STACApi.Catalog("https://stac.geobon.org/")
    @test geobon.title == "BON in a Box STAC"
end

function Base.show(io::IO, catalog::STACApi.Catalog)
    print(io, "📚 $(catalog.title) @ $(catalog.url)")
end