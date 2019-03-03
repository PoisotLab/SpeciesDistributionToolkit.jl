module TestPaging

  using GBIF
  using Test

  # No query
  set = occurrences()
  next!(set)
  @test length(set) == 40
  set.query["limit"] = 40
  next!(set)
  @test length(set) == 80

  # Queries
  lam = occurrences("hasCoordinate" => true, "q" => "Lamellodiscus")
  exp_count = lam.count
  complete!(lam)
  @test length(lam) == exp_count

end
