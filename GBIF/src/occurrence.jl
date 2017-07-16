"""
**Return an interpreted occurrence given its key**
"""
function occurrence(key::Union{String, Integer})
  occ_url = gbifurl * "occurrence/" * string(key)
  occ_key_req = Requests.get(occ_url)
  return Occurrence(Requests.json(occ_key_req))
end

"""
**Search for occurrences**

This function will return the latest occurrences -- usually 20, but this is
entirely determined by the server default page size. This is mostly useful to
get a few results fast.
"""
function occurrences()
  occ_s_url = gbifurl * "occurrence/search"
  occ_s_req = Requests.get(occ_s_url)
  if occ_s_req.status == 200
    body = Requests.json(occ_s_req)
    occ = map(Occurrence, body["results"])
    maxocc = body["count"] > 200000 ? 200000 : body["count"]
    return Occurrences(
      body["offset"],
      maxocc,
      nothing,
      occ
    )
  else
    warn("Non-OK status returned: ", occ_s_req.status)
  end
end

"""
**Search for occurrences**
"""
function occurrences(q::Dict)
  check_occurrences_parameters!(q)
  occ_s_url = gbifurl * "occurrence/search"
  occ_s_req = Requests.get(occ_s_url, query=q)
  if occ_s_req.status == 200
    body = Requests.json(occ_s_req)
    occ = map(Occurrence, body["results"])
    maxocc = body["count"] > 200000 ? 200000 : body["count"]
    return Occurrences(
      body["offset"],
      maxocc,
      q,
      occ
    )
  end
end
