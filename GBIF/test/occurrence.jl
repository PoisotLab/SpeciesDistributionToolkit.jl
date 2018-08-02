module TestOccurrence

  using GBIF
  using Test

  k = 1425221362
  o = occurrence(k)
  @test typeof(o) == GBIFRecord
  @test o.key == k

end
