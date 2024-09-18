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
    req = HTTP.get(Phylopic.api * "autocomplete?query=$(query)")
    if isequal(200)(req.status)
        matches = JSON.parse(String(req.body))["matches"]
        if ~isempty(matches)
            return convert(Vector{String}, matches)
        end
    end
    # WARNING: This probably should not return an empty list here, maybe a `nothing` would
    # make more sense
    return AbstractString[]
end

@testitem "We can autocomplete" begin
    @test ~isempty(Phylopic.autocomplete("chiro"))
end