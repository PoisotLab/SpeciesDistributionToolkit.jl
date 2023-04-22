module Phylopic

import HTTP
import JSON
using UUIDs

const api = "https://api.phylopic.org/"

"""
    Phylopic.ping()

This function will perform a simple ping of the API, and return `nothing` if it is responding, and throw and `ErrorException` (containing the string `"not responding"`) if the API does not returns a `204 No Content` success status.
"""
function ping()
    req = HTTP.get(api * "ping")
    if isequal(204)(req.status)
        return nothing
    else
        throw(ErrorException("The API at $(api) is not responding"))
    end
    return nothing
end

"""
    Phylopic.autocomplete(query::AbstractString)

Performs an autocomplete query based on a string, which must be at least two characters in length.

This function will return an *array* of strings, which can be empty if there are no matches. In you want to do things depending on the values returned, check them with `isempty`, not `isnothing`.

The output of this function, when not empty, can be passed to either `Phylopic.nodes` or `Phylopic.images` using their `filter_name` keyword argument. Note that the `filter_name` argument accepts a *single* name, not an array of names.
"""
function autocomplete(query::AbstractString)
    if length(query) < 2
        throw(ArgumentError("The query ($(query)) must be at least two characters"))
    end
    req = HTTP.get(api * "autocomplete?query=$(query)")
    if isequal(200)(req.status)
        matches = JSON.parse(String(req.body))["matches"]
        if ~isempty(matches)
            return matches
        end
    end
    return AbstractString[]
end

function images(; filter_license_by=false, filter_license_nc=false, filter_license_sa=false, filter_name="")
    query_parameters = ""
    if filter_license_by
        query_parameters *= "filter_license_by=$(filter_license_by)"
    end
    if filter_license_nc
        query_parameters *= "filter_license_nc=$(filter_license_nc)"
    end
    if filter_license_sa
        query_parameters *= "filter_license_sa=$(filter_license_sa)"
    end
    if ~isempty(filter_name)
        query_parameters *= "filter_name=$(filter_name)"
    end
    req = HTTP.get(api * "images?" * replace(query_parameters, " " => "%20"))
    if isequal(200)(req.status)
        @info JSON.parse(String(req.body))
    end
end

end # module Phylopic
