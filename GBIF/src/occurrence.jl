format_querypair_stem(stem::Any) = replace(string(stem), " " => "%20")

function format_querypair_stem(stem::Tuple{T, T}) where {T <: Number}
    m, M = stem
    if (M <= m)
        throw(ArgumentError("Range queries must be formatted as min,max"))
    end
    return replace(string(m) * "," * string(M), " " => "%20")
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
    occurrence(key::String)

Returns a GBIF occurrence identified by a key. The key can be given as a string
or as an integer (there is a second method for integer keys). In case the status
of the HTTP request is anything other than 200 (success), this function *will*
throw an error.
"""
function occurrence(key::String)::GBIFRecord
    occ_url = gbifurl * "occurrence/" * key
    occ_key_req = HTTP.get(occ_url)
    if occ_key_req.status == 200
        result = JSON.parse(String(occ_key_req.body))
        return GBIFRecord(result)
    end
    throw("Occurrence $(key) cannot be accessed")
end

function occurrence(key::Integer)::GBIFRecord
    return occurrence(string(key))
end

function _internal_occurrences_getter(query::Pair...)
    validate_occurrence_query.(query)
    occ_s_url = gbifurl * "occurrence/search"
    occ_s_req = HTTP.get(occ_s_url; query = pairs_to_querystring(query...))
    if occ_s_req.status == 200
        body = JSON.parse(String(occ_s_req.body))
        of_max = body["count"] > 100000 ? 100000 : body["count"]
        this_rec = GBIFRecord.(body["results"])
        return (this_rec, body["offset"], of_max)
    end
    return (nothing, nothing, nothing)
end

"""
    occurrences(query::Pair...)

This function will return the latest occurrences matching the queries -- usually
20, but this is entirely determined by the server default page size. The query
parametes must be given as pairs, and are optional. Omitting the query will
return the latest recorded occurrences for all taxa.

The arguments accepted as queries are documented on the
[GBIF API](https://www.gbif.org/developer/occurrence) website.

**Note that** this function will return even observations where the "occurrenceStatus"
is "ABSENT"; therefore, for the majority of uses, your query will *at least* contain
`"occurrenceStatus" => "PRESENT"`.
"""
function occurrences(query::Pair...)
    retrieved, offset, of_max = _internal_occurrences_getter(query...)
    if !isnothing(retrieved)
        store = Vector{GBIFRecord}(undef, of_max)
        store[1:length(retrieved)] = retrieved
        return GBIFRecords(
            vcat(query...),
            store,
        )
    else
        @error "Nothing retrieved"
    end
end

"""
    occurrences(t::GBIFTaxon, query::Pair...)

Returns occurrences for a given taxon -- the query arguments are the same as the `occurrences` function.
"""
function occurrences(t::GBIFTaxon, query::Pair...)
    levels = [:kingdom, :phylum, :class, :order, :family, :genus, :species]
    level = levels[findlast(l -> getfield(t, l) !== missing, levels)]
    taxon_query = String(level) * "Key" => getfield(t, level).second
    return occurrences(taxon_query, query...)
end

"""
    occurrences(t::Vector{GBIFTaxon}, query::Pair...)

Returns occurrences for a series of taxa -- the query arguments are the same as the `occurrences` function.
"""
function occurrences(ts::Vector{GBIFTaxon}, query::Pair...)
    taxon_query = []
    for t in ts
        levels = [:kingdom, :phylum, :class, :order, :family, :genus, :species]
        level = levels[findlast(l -> getfield(t, l) !== missing, levels)]
        push!(taxon_query, String(level) * "Key" => getfield(t, level).second)
    end
    return occurrences(taxon_query..., query...)
end
