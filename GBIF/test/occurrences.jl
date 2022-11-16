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
while length(obs) < count(obs)
    occurrences!(obs)
end
@test length(obs) == count(obs)

# Version with multiple taxa
serval = GBIF.taxon("Leptailurus serval", strict=true)
leopard = GBIF.taxon("Panthera pardus", strict=true)
obs = occurrences([leopard, serval], "hasCoordinate" => true, "occurrenceStatus" => "PRESENT")
@test typeof(obs) == GBIFRecords

# Version with the full query AND a set page size - this one has about 250 records
obs = occurrences(serval, "hasCoordinate" => "true", "continent" => "AFRICA", "decimalLongitude" => (-30, 40), "limit" => 45)
while length(obs) < count(obs)
    occurrences!(obs)
end
@test length(obs) == count(obs)

# Check ABSENT records
o = occurrences("occurrenceStatus" => "ABSENT")
@test o[1].presence == false

o = occurrences("occurrenceStatus" => "PRESENT")
@test o[1].presence == true

end
