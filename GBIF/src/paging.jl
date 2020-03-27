"""
**Get the next page of results**

This function will retrieve the next page of results. By default, it will walk
through queries 20 at a time. This can be modified by changing the
`.query["limit"]` value, to any value *below* 200.

If filters have been applied to this query before, they will be *removed* to
ensure that the previous and the new occurrences have the same status.
"""
function occurrences(o::GBIFRecords)
  !all(o.show) && allrecords!(o)
  if length(o.occurrences) == o.count
    @info "All occurences for this query have been returned"
  else
    if o.query == nothing
      o.query = Dict{String,Any}()
    end
    @info o.query
    o.query["offset"] = length(o.occurrences)
    o.query["limit"] = get(o.query, "limit", 20)
    if (o.query["offset"] + o.query["limit"]) > o.count
      o.query["limit"] = o.count - o.query["offset"]
    end
    get_next = GBIF.occurrences(o.query)
    append!(o.occurrences, get_next.occurrences)
    append!(o.show, get_next.show)
    o.offset = length(o.occurrences)
    @assert o.offset == length(o.occurrences)
  end
end
