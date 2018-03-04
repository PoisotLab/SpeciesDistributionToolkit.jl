module TestMethods

  using GBIF
  using Base.Test

  set = occurrences()

  @test typeof(set[1]) == GBIFRecord
  @test length(set[1:4]) == 4

end
