"""
**Get the next page of results**

This function will retrieve the next page of results. By default, it will walk
through queries 20 at a time. This can be modified by changing the
`.query["limit"]` value, to any value *below* 200.

If filters have been applied to this query before, they will be *removed* to
ensure that the previous and the new occurrences have the same status.
"""
function occurrences!(o::GBIFRecords)
  !all(o.show) && allrecords!(o)
  if length(o.occurrences) == o.count
    @info "All occurences for this query have been returned"
  else
    if o.query == nothing
      o.query = Dict{String,Any}()
    end
    offset = length(o.occurrences)
    limit_index = findfirst((p) -> string(p.first) == "limit", o.query)
    limit = isnothing(limit_index) ? 20 : o.query[limit_index].second
    if (offset + limit) > o.count
      deleteat!(o.query, limit_index)
      push!(o.query, "limit" => o.count - offset)
    end
    get_next = GBIF.occurrences("offset" => offset, o.query...)
    append!(o.occurrences, get_next.occurrences)
    append!(o.show, get_next.show)
    o.offset = length(o.occurrences)
    @assert o.offset == length(o.occurrences)
  end
end
