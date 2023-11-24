"""
    _get_uuids_at_page(query, page)

This function is an internal helped function to return an array of pairs, wherein each pair maps a name to a UUID, for a given query and page. These outpurs are collected in a dictionary by `Phylopic.names`.
"""
function _get_uuids_at_page(query, page)
    page_query = push!(query, "page" => page - 1)
    req = HTTP.get(Phylopic.api * "images"; query = page_query)
    if isequal(200)(req.status)
        response = JSON.parse(String(req.body))
        return [
            item["title"] => UUIDs.UUID(
                replace(
                    item["href"],
                    "/images/" => "",
                    "?build=$(Phylopic.buildnumber)" => "",
                ),
            ) for item in response["_links"]["items"]
        ]
    end
    return nothing
end

"""
    imagesof(name::AbstractString; items=1, attribution=false, sharealike=false, nocommercial=false)

Returns a mapping between names and UUIDs of images for a given text (see also `Phylopic.autocomplete` to find relevant names). By default, the search will return images that come without BY, SA, and NC clauses (*i.e.* public domain dedication), but this can be changed using the keyword arguments.

`items`
: Default to 1
: Specifies the number of items to return. When a single item is returned, it is return as a pair mapping the name to the UUID; when there are more than 1, they are returned as a dictionary

`attribution`
: Default to `false`
: Specifies whether the images returned require attribution to the creator

`sharealike`
: Default to `false`
: Specifies whether the images returned require sharing of derived products using a license with a SA clause

`nocommercial`
: Default to `false`
: Specifies whether the images returned are prevented from being used in commercial projects
"""
function imagesof(
    name::AbstractString;
    items = 1,
    attribution = false,
    sharealike = false,
    nocommercial = false,
)
    name = lowercase(replace(name, r"\s+" => " "))
    query = [
        "filter_name" => name,
        "filter_license_by" => attribution,
        "filter_license_nc" => nocommercial,
        "filter_license_sa" => sharealike,
        "build" => Phylopic.buildnumber,
    ]
    req = HTTP.get(Phylopic.api * "images"; query = query)
    if isequal(200)(req.status)
        response = JSON.parse(String(req.body))
        if iszero(response["totalItems"])
            return nothing
        end
        if response["totalItems"] < items
            @warn "Only $(response["totalItems"]) are available, you requested $(items)"
        end
        n_pages = ceil(items / response["itemsPerPage"])
        uuids = vcat([_get_uuids_at_page(query, page) for page in n_pages]...)
        if isone(length(uuids))
            return only(uuids)
        else
            toreturn = min(items, response["totalItems"])
            if isone(toreturn)
                return first(uuids)
            else
                return Dict(uuids[1:toreturn])
            end
        end
    end
    return nothing
end

@testitem "We get a single image as a pair" begin
    @test typeof(Phylopic.imagesof("chiroptera")) == Pair{String, Base.UUID}
end

@testitem "We get multiple images as a dict" begin
    @test typeof(Phylopic.imagesof("chiroptera"; items = 2)) == Dict{String, Base.UUID}
end