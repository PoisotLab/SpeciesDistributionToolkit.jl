module TestDataFrame

  using GBIF
  using DataFrames
  using Base.Test

  o = occurrences()

  @test size(DataFrame(o), 1) == 20

end
