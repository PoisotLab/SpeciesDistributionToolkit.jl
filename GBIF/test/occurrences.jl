module TestOccurrences

  using GBIF
  using Base.Test

  qpars = Dict("scientificName" => "Mus musculus", "year" => 1999, "hasCoordinate" => true)
  set = occurrences(qpars)
  @test typeof(set) == Occurrences
  @test length(set) == 20

  set2 = occurrences()
  @test typeof(set2) == Occurrences
  @test length(set2) == 20

end
