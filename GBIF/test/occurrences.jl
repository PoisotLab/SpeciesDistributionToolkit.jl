module TestGBIFRecords

  using GBIF
  using Test

  # Version using pairs
  set3 = occurrences("scientificName" => "Mus musculus", "year" => 1999, "hasCoordinate" => true)
  @test typeof(set3) == GBIFRecords
  @test length(set3) == 20

  # Version with no query parameters
  set2 = occurrences()
  @test typeof(set2) == GBIFRecords
  @test length(set2) == 20

end
