"""
**Get the next page of results**

This function will retrieve the next page of results. By default, it will walk
through queries 20 at a time. This can be modified by changing the
`.query["limit"]` value, to any value *below* 200.
"""
function next!(o::GBIFRecords)
  if length(o) == o.count
    info("All occurences for this query have been returned")
  else
    if o.query == nothing
      o.query = Dict{String,Any}()
    end
    o.query["offset"] = length(o)
    o.query["limit"] = get(o.query, "limit", 20)
    if (o.query["offset"] + o.query["limit"]) > o.count
      o.query["limit"] = o.count - o.query["offset"]
    end
    get_next = GBIF.occurrences(o.query)
    append!(o.raw, get_next.raw)
    append!(o.show, get_next.show)
    update!(o)
    o.offset = length(o.occurrences)
    @assert o.offset == length(o.occurrences)
  end
end

"""
**Get all pages of results**

This function will retrieve *all* matches (up to the GBIF limit of 200000
records for a streaming query). It is recommended to set the limit to more than
the default of 20 before calling this function. If not, this will trigger a lot
of requests both from your end and on the GBIF infrastructure.

Internally, this function is simply calling `next!` until all records are
exhausted. 
"""
function complete!(o::GBIFRecords)
  while length(o.occurrences) < o.count
    next!(o)
  end
end
