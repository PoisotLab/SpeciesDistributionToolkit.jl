struct Collection
    id::String
    description::String
    license::String
    bbox::Vector{Number}
    t0::DateTime
    tf::DateTime
end

function collections(catalog::STACApi.Catalog)
    req = HTTP.get(catalog.url * "collections")
    output = __handle_get_response(req)
    @assert "collections" in keys(output)
    collecs = STACApi.Collection[]
    for collec in output["collections"]
        push!(collecs, Collection(
            collec.id, collec.description, collec.license,
            collect(first(collec.extent.spatial.bbox)),
            parse.(DateTime, collec.extent.temporal.interval[1], dateformat"yyyy-mm-ddTH:M:SZ")...
        ))
    end
    return collecs
end

@testitem "We can get the collections" begin
    geobon = STACApi.Catalog("https://stac.geobon.org/")
    coll = STACApi.collections(geobon)
    @test !isnothing(findfirst(x -> x.id == "gfw-gain", coll))
end

Base.show(io::IO, collection::STACApi.Collection) = print(io, "📃 $(collection.id)")

Base.getindex(catalog::Catalog, id::String) = collections(catalog)[findfirst(x -> x.id == id, collections(catalog))]

@testitem "We can get a collection by id" begin
    geobon = STACApi.Catalog("https://stac.geobon.org/")
    @test geobon["colombia-lc"].id == "colombia-lc"
end