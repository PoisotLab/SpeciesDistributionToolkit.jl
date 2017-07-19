module TestPaging

  using GBIF
  using Base.Test

  # No query
  set = occurrences()
  next!(set)
  @test length(set) == 40
  set.query["limit"] = 40
  next!(set)
  @test length(set) == 80

  # Queries
  qpars = Dict{String,Any}(
    "hasCoordinate" => true,
    "q" => "Lamellodiscus"
  )
  lam = occurrences(qpars)
  exp_count = lam.count
  complete!(lam)
  @test length(lam) == exp_count

end
