import HTTP
import JSON

"""
    Phylopic.ping()

This function will perform a simple ping of the API, and return `nothing` if it is responding, and throw and `ErrorException` (containing the string `"not responding"`) if the API does not returns a `204 No Content` success status.
"""
function ping()
    req = HTTP.get(Phylopic.api * "ping")
    if isequal(204)(req.status)
        return nothing
    else
        throw(ErrorException("The API at $(Phylopic.api) is not responding"))
    end
    return nothing
end

@testitem "We can connect" begin
    @test isnothing(Phylopic.ping())
end