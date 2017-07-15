"""
**Checks that the queries for occurrences searches are well formatted**

This is used internally.

Everything this function does is derived from the GBIF API documentation,
including the values for enum types. This modifies the queryset. Filters that
are not allowed are removed, and filters that have incorrect values are dropped
too.

This feels like the most conservative option -- the user can always filter the
results when they are returned.
"""
function check_occurrences_parameters!(q::Dict)
  # List of fields from GBIF

  allowed_fields = "q", "basisOfRecord", "catalogNumber", "collectionCode",
    "continent", "country", "datasetKey", "decimalLatitude", "decimalLongitude",
    "depth", "elevation", "eventDate", "geometry", "hasCoordinate",
    "hasGeospatialIssue", "institutionCode", "issue", "lastInterpreted",
    "mediaType", "month", "occurrenceId", "organismId", "protocol", "license",
    "publishingCountry", "publishingOrg", "crawlId", "recordedBy", "recordNumber",
    "scientificName", "locality", "stateProvince", "waterBody", "taxonKey",
    "kingdomKey", "phylumKey", "classKey", "orderKey", "familyKey", "genusKey",
    "subGenusKey", "speciesKey", "year", "establishmentMeans", "repatriated",
    "typeStatus", "facet", "facetMincount", "facetMultiselect"

  for (k, v) in q
    if !(k ∈ allowed_fields)
      warn(k, " is not a supported field -- will be dropped from the queryset")
      delete!(q, k)
    end
  end

end
