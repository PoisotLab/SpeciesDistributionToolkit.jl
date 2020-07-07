module TestQuery

  using GBIF
  using Query
  using DataFrames
  using Test

  t = taxon("Carnivora", strict=false)
  set = occurrences(t)
  [occurrences!(set) for i in 1:10]

  tdf = view(set) |>
    @filter(_.rank == "SPECIES") |>
    @map({_.key, _.taxon.name, _.country}) |>
    DataFrame

  @test typeof(tdf) <: DataFrame

  tdf2 = for s in view(set) begin
    @where s.rank == "SPECIES"
    @select s
    @collect
  end

  @test typeof(tdf2) <: Vector{GBIFRecord}

end
end
