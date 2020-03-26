"""
**Return an interpreted occurrence given its key**

	occurrence(key::Union{String, Integer})

The key can be given as a string or as an integer.
"""
function occurrence(key::Union{String, Integer})
  occ_url = gbifurl * "occurrence/" * string(key)
  occ_key_req = HTTP.get(occ_url)
  result = JSON.parse(String(occ_key_req.body))
  return GBIFRecord(result)
end

"""
**Retrieve latest occurrences based on a query**

    occurrences(query::Pair...)

This function will return the latest occurrences matching the queries -- usually
20, but this is entirely determined by the server default page size. The query
parametes must be given as pairs, and are optional. Omitting the query will
return the latest recorded occurrences.
"""
function occurrences(query::Pair...)
	# TODO check_records_parameters!(query)
	occ_s_url = gbifurl * "occurrence/search"
	occ_s_req = length(query) > 0 ? HTTP.get(occ_s_url; query=query) : HTTP.get(occ_s_url)
	if occ_s_req.status == 200
		body = JSON.parse(String(occ_s_req.body))
		occ = GBIFRecord.(body["results"])
		maxocc = body["count"] > 200000 ? 200000 : body["count"]
		return GBIFRecords(
			body["offset"],
			maxocc,
			vcat(query...),
			occ,
			ones(Bool, length(occ))
		)
	else
		@error "Non-OK status returned: $(occ_s_req.status)"
	end
end


"""
**Retrieve latest occurrences for a taxon based on a query**

    occurrences(t::GBIFTaxon, query::Pair...)

Returns occurrences that correspond to a filter, given in `q` as a dictionary.
When first called, this function will return the latest 20 hits (or whichever
default page size GBIF uses). Future occurrences can be queried with `next!` or
`complete!`.
"""
function occurrences(t::GBIFTaxon, query::Pair...)
	levels = [:kingdom, :phylum, :class, :order, :family, :genus, :species]
	filter!(l -> getfield(t, l) !== nothing, levels)
	level = levels[end]
	taxon_query = String(level)*"Key" => getfield(t, level).second
	return occurrences(taxon_query, query...)
end
