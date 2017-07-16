"""
**Get the next page of the results**
"""
function next!(o::Occurrences)
  o.query["offset"] = o.offset + length(o.occurrences)
  get_next = GBIF.occurrences(o.query)
  append!(o.occurrences, get_next.occurrences)
  o.offset = length(o.occurrences)
end
