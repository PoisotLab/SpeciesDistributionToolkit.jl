"""
    longitudes(record::GBIF.GBIFRecord)

Returns the longitude associated to a GBIF record
"""
longitudes(record::GBIF.GBIFRecord) = record.longitude

"""
    latitudes(record::GBIF.GBIFRecord)

Returns the latitude associated to a GBIF record
"""
latitudes(record::GBIF.GBIFRecord) = record.latitude

"""
    latitudes(records::GBIF.GBIFRecords)

Returns the non-missing latitudes from a series of records
"""
latitudes(records::GBIF.GBIFRecords) =
    filter(!ismissing, [latitudes(record) for record in records])

"""
    latitudes(records::GBIF.GBIFRecords)

Returns the non-missing latitudes from a series of records
"""
longitudes(records::GBIF.GBIFRecords) =
    filter(!ismissing, [longitudes(record) for record in records])
