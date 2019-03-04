module TestGBIFRecords

  using GBIF
  using Test

  set2 = occurrences()
  @test typeof(set2) == GBIFRecords
  @test length(set2) == 20

  # Version using pairs
  set3 = occurrences("scientificName" => "Mus musculus", "year" => 1999, "hasCoordinate" => true)
  @test typeof(set3) == GBIFRecords
  @test length(set3) == 20

end
