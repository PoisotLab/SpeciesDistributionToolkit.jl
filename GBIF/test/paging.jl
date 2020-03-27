module TestPaging

  using GBIF
  using Test

  # No query
  set = occurrences()
  occurrences(set)
  @test length(set) == 40
  set.query["limit"] = 40
  occurrences(set)
  @test length(set) == 80

end
