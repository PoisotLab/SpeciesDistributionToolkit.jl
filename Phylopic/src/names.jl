"""
    _get_uuids_at_page(query, page)

This function is an internal helped function to return an array of pairs, wherein each pair maps a name to a UUID, for a given query and page. These outpurs are collected in a dictionary by `Phylopic.names`.
"""
function _get_uuids_at_page(query, page)
    page_query = push!(query, "page" => page - 1)
    req = HTTP.get(Phylopic.api * "images", query=page_query)
    if isequal(200)(req.status)
        response = JSON.parse(String(req.body))
        return [item["title"] => UUIDs.UUID(replace(item["href"], "/images/" => "", "?build=$(Phylopic.buildnumber)" => "")) for item in response["_links"]["items"]]
    end
    return nothing
end

function names(name::AbstractString; items=1)
    name = lowercase(replace(name, r"\s+" => " "))
    query = [
        "filter_name" => name,
        "build" => Phylopic.buildnumber
    ]
    req = HTTP.get(Phylopic.api * "images", query=query)
    if isequal(200)(req.status)
        response = JSON.parse(String(req.body))
        if iszero(response["totalItems"])
            return nothing
        end
        if response["totalItems"] < items
            @warn "Only $(response["totalItems"]) are available, you requested $(items)"
        end
        n_pages = ceil(items / response["itemsPerPage"])
        uuids = Dict(vcat([_get_uuids_at_page(query, page) for page in n_pages]...))
        return length(uuids) == 1 ? only(collect(uuids)) : uuids
    end
    return nothing
end
