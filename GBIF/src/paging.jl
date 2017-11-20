"""
**Get the next page of results**
"""
function next!(o::Occurrences)
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
"""
function complete!(o::Occurrences)
  while length(o.occurrences) < o.count
    next!(o)
  end
end
