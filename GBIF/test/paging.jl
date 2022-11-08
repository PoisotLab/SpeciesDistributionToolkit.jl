module TestPaging

  using GBIF
  using Test

  # No query
  set = occurrences()
  occurrences!(set)
  @test length(set) == 40

  # No query, different limit
  set = occurrences("limit" => 40)
  occurrences!(set)
  @test length(set) == 80
  @test length(set) == length(unique([o.key for o in set]))

  # Query and different limit
  setQ = occurrences(taxon("Iris versicolor", rank=:SPECIES), "limit" => 10)
  occurrences!(setQ)
  @test length(setQ) == 20
  occurrences!(setQ)
  @test length(setQ) == length(unique([o.key for o in setQ]))

end
