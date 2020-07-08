module TestQuery

  using GBIF
  using DataFrames
  using Query
  using Test

  t = taxon("Mammalia", strict=false)
  set = occurrences(t)
  [occurrences!(set) for i in 1:10]

  tdf = view(set) |>
    @filter(_.rank == "SPECIES") |>
    @map({_.key, _.taxon.name, _.country}) |>
    DataFrame

  @test typeof(tdf) <: DataFrame

end
