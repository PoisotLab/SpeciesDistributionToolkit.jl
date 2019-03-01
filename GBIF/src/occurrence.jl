"""
**Return an interpreted occurrence given its key**

	occurrence(key::Union{String, Integer})

The key can be given as a string or as an integer.
"""
function occurrence(key::Union{String, Integer})
  occ_url = gbifurl * "occurrence/" * string(key)
  occ_key_req = HTTP.get(occ_url)
  return GBIFRecord(JSON.parse(String(occ_key_req.body)))
end

"""
**Retrieve latest occurrences**

    occurrences()

This function will return the latest occurrences -- usually 20, but this is
entirely determined by the server default page size. This is mostly useful to
get a few results rapidly for illustration purposes.
"""
function occurrences()
  occ_s_url = gbifurl * "occurrence/search"
  occ_s_req = HTTP.get(occ_s_url)
  if occ_s_req.status == 200
    body = JSON.parse(String(occ_s_req.body))
    occ = map(GBIFRecord, body["results"])
    maxocc = body["count"] > 200000 ? 200000 : body["count"]
    return GBIFRecords(
      body["offset"],
      maxocc,
      nothing,
      occ,
      ones(Bool, length(occ))
    )
  else
    @error "Non-OK status returned: $(occ_s_req.status)"
  end
end

"""
**Retrieve latest occurrences**

    occurrences(query::Pair...)

This function will return the latest occurrences -- usually 20, but this is
entirely determined by the server default page size. This is mostly useful to
get a few results rapidly for illustration purposes.
"""
function occurrences(query::Pair...)
  occ_s_url = gbifurl * "occurrence/search"
  occ_s_req = HTTP.get(occ_s_url; query=query...)
  if occ_s_req.status == 200
    body = JSON.parse(String(occ_s_req.body))
    occ = map(GBIFRecord, body["results"])
    maxocc = body["count"] > 200000 ? 200000 : body["count"]
    return GBIFRecords(
      body["offset"],
      maxocc,
      nothing,
      occ,
      ones(Bool, length(occ))
    )
  else
    @error "Non-OK status returned: $(occ_s_req.status)"
  end
end

"""
**Retrieve latest occurrences based on a query**

    occurrences(q::Dict)

Returns occurrences that correspond to a filter, given in `q` as a dictionary.
When first called, this function will return the latest 20 hits (or whichever
default page size GBIF uses). Future occurrences can be queried with `next!` or
`complete!`.
"""
function occurrences(q::Dict)
  check_records_parameters!(q)
  occ_s_url = gbifurl * "occurrence/search"
  occ_s_req = HTTP.get(occ_s_url, query=q)
  if occ_s_req.status == 200
    body = JSON.parse(String(occ_s_req.body))
    occ = map(GBIFRecord, body["results"])
    maxocc = body["count"] > 200000 ? 200000 : body["count"]
    return GBIFRecords(
      body["offset"],
      maxocc,
      q,
      occ,
      ones(Bool, length(occ))
    )
  end
end

"""
**Retrieve latest occurrences for a taxon based on a query**

    occurrences(t::GBIFTaxon, q::Dict)

Returns occurrences that correspond to a filter, given in `q` as a dictionary.
When first called, this function will return the latest 20 hits (or whichever
default page size GBIF uses). Future occurrences can be queried with `next!` or
`complete!`.
"""
function occurrences(t::GBIFTaxon, q::Dict)
	levels = [:kingdom, :phylum, :class, :order, :family, :genus, :species]
	for l in levels
		if getfield(t, l) !== nothing
			q[String(l)*"Key"] = getfield(t, l).second
		end
	end
	return occurrences(q)
end

"""
**Retrieve latest occurrences for a taxon**

    occurrences(t::GBIFTaxon)

Returns occurrences that correspond to a filter, given in `q` as a dictionary.
When first called, this function will return the latest 20 hits (or whichever
default page size GBIF uses). Future occurrences can be queried with `next!` or
`complete!`.
"""
function occurrences(t::GBIFTaxon)
	return occurrences(t, Dict())
end
