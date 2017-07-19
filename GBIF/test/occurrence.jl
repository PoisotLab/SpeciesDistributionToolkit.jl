module TestOccurrence

  using GBIF
  using Base.Test

  k = 1425221362
  o = occurrence(k)
  @test typeof(o) == Occurrence
  @test o.key == k

end
