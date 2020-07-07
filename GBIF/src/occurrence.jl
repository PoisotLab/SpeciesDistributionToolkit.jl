format_querypair_stem(stem::Any) = replace(string(stem), " " => "%20")

function format_querypair_stem(stem::Tuple{T,T}) where {T <: Number}
	m, M = stem
	if (M <= m )
		throw(ArgumentError("Range queries must be formatted as min,max"))
	end
	return replace(string(m)*","*string(M), " " => "%20")
end


function pairs_to_querystring(query::Pair...)
	if length(query) == 0
		return ""
	else
		# We start from an empty query string
		querystring = ""
		for (i, pair) in enumerate(query)
			# We build it pairwise for every
			delim = i == 1 ? "" : "&" # We use & to delimitate the queries
			# Let's be extra cautious and encode the spaces correctly
			root = replace(string(pair.first), " " => "%20")
			stem = format_querypair_stem(pair.second)
			# Then we can graft the pair string onto the query string
			pairstring = "$(delim)$(root)=$(stem)"
			querystring *= pairstring
		end
		return querystring
	end
end

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

function _internal_occurrences_getter(query::Pair...)
	validate_occurrence_query.(query)
	occ_s_url = gbifurl * "occurrence/search"
	occ_s_req = HTTP.get(occ_s_url; query=pairs_to_querystring(query...))
	if occ_s_req.status == 200
		body = JSON.parse(String(occ_s_req.body))
		of_max = body["count"] > 100000 ? 100000 : body["count"]
		this_rec = GBIFRecord.(body["results"])
		return (this_rec, body["offset"], of_max)
	end
	return (nothing, nothing, nothing)
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
	retrieved, offset, of_max = _internal_occurrences_getter(query...)
	if !isnothing(retrieved)
		store = Vector{GBIFRecord}(undef, of_max)
		store[1:length(retrieved)] = retrieved
		return GBIFRecords(
			offset,
			of_max,
			vcat(query...),
			store
		)
	else
		@error "Nothing retrieved"
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
	level = levels[findlast(l -> getfield(t, l) !== missing, levels)]
	taxon_query = String(level)*"Key" => getfield(t, level).second
	return occurrences(taxon_query, query...)
end
