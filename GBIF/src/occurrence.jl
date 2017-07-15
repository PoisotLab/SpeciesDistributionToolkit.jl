"""
**Return an interpreted occurrence given its key**
"""
function occurrence(key::Union{String, Integer})
  occ_url = gbifurl * "occurrence/" * string(key)
  occ_key_req = Requests.get(occ_url)
  return Requests.json(occ_key_req)
end

"""
**Search for occurrences**
"""
function occurrences()
  occ_s_url = gbifurl * "occurrence/search"
  occ_s_req = Requests.get(occ_s_url)
  return Requests.json(occ_s_req)
end

"""
**Search for occurrences**
"""
function occurrences(q::Dict)
  check_occurrences_parameters!(q)
  occ_s_url = gbifurl * "occurrence/search"
  occ_s_req = Requests.get(occ_s_url, query=q)
  return Requests.json(occ_s_req)
end
