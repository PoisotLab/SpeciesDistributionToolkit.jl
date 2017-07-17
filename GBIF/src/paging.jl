"""
**Restart a query that was previously filtered**

This function will overwrite the current set of results, and reset all searches.
"""
function restart!(o::Occurrences)
  if o.cleaned == true
    q = o.query == nothing ? occurrences() : occurrences(o.query)
    o.cleaned = false
    o.count = q.count
    o.offset = q.offset
    o.occurrences = deepcopy(q.occurrences)
  end
end

"""
**Get the next page of results**
"""
function next!(o::Occurrences)
  if o.cleaned
    warn("A filtered list of occurences cannot be resumed - object unchanged")
  else
    if length(o.occurrences) == o.count
      info("All occurences for this query have been returned")
    else
      o.query["offset"] = length(o.occurrences)
      o.query["limit"] = get(o.query, "limit", 20)
      if (o.query["offset"] + o.query["limit"]) > o.count
        o.query["limit"] = o.count - o.query["offset"]
      end
      get_next = GBIF.occurrences(o.query)
      append!(o.occurrences, get_next.occurrences)
      o.offset = length(o.occurrences)
      @assert o.offset == length(o.occurrences)
    end
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
