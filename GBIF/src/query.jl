"""
**Checks that the queries for occurrences searches are well formatted**

This is used internally.

Everything this function does is derived from the GBIF API documentation,
including (and especially) the values for enum types. This modifies the
queryset. Filters that are not allowed are removed, and filters that have
incorrect values are dropped too.

This feels like the most conservative option -- the user can always filter the
results when they are returned.
"""
function validate_occurrence_query(query::Pair)

    # List of fields from GBIF
    allowed_fields = [
        "q",
        "basisOfRecord",
        "catalogNumber",
        "collectionCode",
        "continent",
        "country",
        "datasetKey",
        "decimalLatitude",
        "decimalLongitude",
        "depth",
        "elevation",
        "eventDate",
        "geometry",
        "hasCoordinate",
        "hasGeospatialIssue",
        "institutionCode",
        "issue",
        "lastInterpreted",
        "mediaType",
        "month",
        "occurrenceId",
        "occurrenceStatus",
        "organismId",
        "protocol",
        "license",
        "publishingCountry",
        "publishingOrg",
        "crawlId",
        "recordedBy",
        "recordNumber",
        "scientificName",
        "locality",
        "stateProvince",
        "waterBody",
        "taxonKey",
        "kingdomKey",
        "phylumKey",
        "classKey",
        "orderKey",
        "familyKey",
        "genusKey",
        "subGenusKey",
        "speciesKey",
        "year",
        "establishmentMeans",
        "repatriated",
        "typeStatus",
        "facet",
        "facetMincount",
        "facetMultiselect",
        "limit",
        "offset",
    ]

    if !(query.first ∈ allowed_fields)
        @error "The $(query.first) parameter is not allowed by the GBIF API"
    end

    # Country must be a two-letters country code
    if query.first == "country"
        if length(query.second) != 2
            @error "$(query.second) is not a two letter country code"
        end
    end

    # Latitude and longitudes
    # TODO lat -90/90 lon -180/180, can be "min,max"

    # ENUMs
    if query.first ∈ keys(gbifenums)
        @assert query.second ∈ gbifenums[query.first]
    end
end
