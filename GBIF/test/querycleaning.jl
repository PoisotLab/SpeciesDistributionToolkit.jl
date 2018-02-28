module TestQuery

  using GBIF
  using Base.Test

  # Filtering with wrong parameters
  qpars = Dict("country" => "ABC")
  @test_warn "country code" GBIF.check_records_parameters!(qpars)

  qpars = Dict("years" => "1234")
  @test_warn "not a supported field" GBIF.check_records_parameters!(qpars)

  qpars = Dict("establishmentMeans" => "LOLWUT")
  @test_warn "values in establishmentMeans were invalid" GBIF.check_records_parameters!(qpars)

end
