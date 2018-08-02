module TestGBIFRecords

  using GBIF
  using Test

  qpars = Dict("scientificName" => "Mus musculus", "year" => 1999, "hasCoordinate" => true)
  set = occurrences(qpars)
  @test typeof(set) == GBIFRecords
  @test length(set) == 20

  set2 = occurrences()
  @test typeof(set2) == GBIFRecords
  @test length(set2) == 20

end
