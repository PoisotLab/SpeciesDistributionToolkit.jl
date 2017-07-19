module TestMethods

  using GBIF
  using Base.Test

  set = occurrences()

  @test typeof(set[1]) == Occurrence
  @test length(set[1:4]) == 4

end
