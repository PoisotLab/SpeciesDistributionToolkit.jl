"""
**Format an occurrence object**
"""
function format_occurrence_response(r::HttpCommon.Response)
  if r.status == 200
    return Requests.json(r)
  end
end

"""
**Return an interpreted occurrence given its key**
"""
function occurrence(key::Union{String, Integer})
  occ_url = gbifurl * "occurrence/" * string(key)
  occ_key_req = Requests.get(occ_url)
  return format_occurrence_response(r)
end
