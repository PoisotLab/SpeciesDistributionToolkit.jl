function check_occurrences_parameters!(q::Dict)
  # List of fields from GBIF

  allowed_fields = "q", "basisOfRecord", "catalogNumber", "collectionCode", "continent", "country", "datasetKey", "decimalLatitude", "decimalLongitude", "depth", "elevation", "eventDate", "geometry", "hasCoordinate", "hasGeospatialIssue", "institutionCode", "issue", "lastInterpreted", "mediaType", "month", "occurrenceId", "organismId", "protocol", "license", "publishingCountry", "publishingOrg", "crawlId", "recordedBy", "recordNumber", "scientificName", "locality", "stateProvince", "waterBody", "taxonKey", "kingdomKey", "phylumKey", "classKey", "orderKey", "familyKey", "genusKey", "subGenusKey", "speciesKey", "year", "establishmentMeans", "repatriated", "typeStatus", "facet", "facetMincount", "facetMultiselect"

  for (k, v) in q
    if !(k ∈ allowed_fields)
      warn(k, " is not a supported field -- will be dropped from the queryset")
      delete!(q, k)
    end
  end

end
