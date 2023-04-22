module Phylopic

import HTTP
import JSON

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

end # module Phylopic
