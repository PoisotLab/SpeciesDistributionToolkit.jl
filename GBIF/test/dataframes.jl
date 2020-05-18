module TestDataFrames

  using GBIF
  using DataFrames
  using Test

  df = DataFrame(occurrences())

  @test typeof(df) <: DataFrame


end
