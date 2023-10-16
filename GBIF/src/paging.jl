function _internal_offset_update!(o::GBIFRecords)
    offset = length(o)
    offset_index = findfirst((p) -> string(p.first) == "offset", o.query)
    if isnothing(offset_index)
        push!(o.query, "offset" => offset)
    else
        deleteat!(o.query, offset_index)
        push!(o.query, "offset" => offset)
    end
end

function _internal_limit_update!(o::GBIFRecords)
    limit_index = findfirst((p) -> string(p.first) == "limit", o.query)
    limit = isnothing(limit_index) ? 20 : o.query[limit_index].second
    if (length(o) + limit) > count(o)
        isnothing(limit_index) || deleteat!(o.query, limit_index)
        push!(o.query, "limit" => count(o) - length(o))
    end
end

"""
**Get the next page of results**

This function will retrieve the next page of results. By default, it will walk
through queries 20 at a time. This can be modified by changing the
`.query["limit"]` value, to any value *up to* 300, which is the limit set by
GBIF for the queries.

If filters have been applied to this query before, they will be *removed* to
ensure that the previous and the new occurrences have the same status, but only
for records that have already been retrieved.
"""
function occurrences!(o::GBIFRecords)
    if length(o) == count(o)
        @info "All occurrences for this query have been returned"
    else
        if isnothing(o.query)
            o.query = Dict{String, Any}()
        end
        _internal_offset_update!(o)
        _internal_limit_update!(o)
        offset = length(o)
        # Retrieve and add
        retrieved, _, of_max = _internal_occurrences_getter(o.query...)
        start = length(o) + 1
        stop = start + length(retrieved) - 1
        o.occurrences[start:stop] = retrieved
    end
end

@testitem "We always get one page by default" begin
    set = occurrences()
    occurrences!(set)
    @test length(set) == 40
end

@testitem "We can get multiple pages on repeated calls" begin
    set = occurrences("limit" => 40)
    occurrences!(set)
    @test length(set) == 80
    @test length(set) == length(unique([o.key for o in set]))
end

@testitem "We can page over queries" begin
    setQ = occurrences(taxon("Iris versicolor", rank=:SPECIES), "limit" => 10)
    occurrences!(setQ)
    @test length(setQ) == 20
    occurrences!(setQ)
    @test length(setQ) == length(unique([o.key for o in setQ]))
end