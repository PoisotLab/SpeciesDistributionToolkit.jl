"""
**Get the next page of results**

This function will retrieve the next page of results. By default, it will walk
through queries 20 at a time. This can be modified by changing the
`.query["limit"]` value, to any value *below* 300, which is the limit set
by GBIF for the queries.

If filters have been applied to this query before, they will be *removed* to
ensure that the previous and the new occurrences have the same status, but only
for records that have already been retrieved.
"""
function occurrences!(o::GBIFRecords)
  if length(o) == o.count
    @info "All occurences for this query have been returned"
  else
    if o.query == nothing
      o.query = Dict{String,Any}()
    end
    offset = length(o)
    limit_index = findfirst((p) -> string(p.first) == "limit", o.query)
    limit = isnothing(limit_index) ? 20 : o.query[limit_index].second
    if (offset + limit) > o.count
      deleteat!(o.query, limit_index)
      push!(o.query, "limit" => o.count - offset)
    end
    retrieved, offset, of_max = _internal_occurrences_getter(o.query...)
    start = length(o)+1
    stop = start + length(retrieved) - 1
    o.occurrences[start:stop] = retrieved
  end
end
