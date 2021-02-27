module TestGBIFRecords

using GBIF
using Test

# Version using pairs
set1 = occurrences("scientificName" => "Mus musculus", "year" => 1999, "hasCoordinate" => true)
@test typeof(set1) == GBIFRecords
@test length(set1) == 20

# Version with no query parameters
set2 = occurrences()
@test typeof(set2) == GBIFRecords
@test length(set2) == 20

# Version using ranged pairs
set3 = occurrences("scientificName" => "Mus musculus", "year" => 1999, "hasCoordinate" => true, "decimalLatitude" => (0.0, 50.0))
@test typeof(set3) == GBIFRecords
@test length(set3) == 20

# Version with the full query - this one has about 250 records
serval = GBIF.taxon("Leptailurus serval", strict=true)
obs = occurrences(serval, "hasCoordinate" => "true", "continent" => "AFRICA", "decimalLongitude" => (-30, 40))
while length(obs) < size(obs)
    occurrences!(obs)
end
@test length(obs) == size(obs)

# Version with the full query AND a set page size - this one has about 250 records
obs = occurrences(serval, "hasCoordinate" => "true", "continent" => "AFRICA", "decimalLongitude" => (-30, 40), "limit" => 45)
while length(obs) < size(obs)
    occurrences!(obs)
end
@test length(obs) == size(obs)

end
