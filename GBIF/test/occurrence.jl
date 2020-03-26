module TestOccurrence

  using GBIF
  using Test

  k = 1258202889
  o = occurrence(k)
  @test typeof(o) == GBIFRecord
  @test o.key == k

  # Piece of shit uncorrectly formatted occurence
  k = 1039645472
  o = occurrence(k)
  @test typeof(o) == GBIFRecord

end
