import JSON
import HTTP
import UUIDs

"""
This type exists only to dispatch the `_get_image_querystring_from_pairs` correctly.
"""
struct PhylopicImage end

function _format(::Type{PhylopicImage}; prefix="filter", kwargs...)
    querystring = ""
    prefix_in_query = isempty(prefix) ? "" : "$(prefix)_"
    for pair in kwargs
        querystring *= "&$(prefix_in_query)$(pair.first)=$(pair.second)"
    end
    return querystring
end

function images(; filter=nothing, page=nothing)
    querystring = ""
    if ~isnothing(filter)
        querystring *= _format(PhylopicImage; filter...)
    end
    if ~isnothing(page)
        querystring *= "&page=$(page)&build=$(Phylopic.buildnumber)"
    end
    req = HTTP.get(Phylopic.api * "images?" * replace(querystring, " " => "%20"))
    if isequal(200)(req.status)
        result = JSON.parse(String(req.body))
        if isnothing(page)
            return result["totalPages"]
        else
            stripimg = (h) -> replace(h, "/images/" => "", "?build=$(Phylopic.buildnumber)" => "")
            return Dict([link["title"] => UUIDs.UUID(stripimg(link["href"])) for link in result["_links"]["items"]])
        end
    end
end

function images(u::UUIDs.UUID)
    querystring = "images/$(string(u))?build=$(Phylopic.buildnumber)"
    req = HTTP.get(Phylopic.api * querystring)
    if isequal(200)(req.status)
        results = JSON.parse(String(req.body))
        return results
    end
end
