module TestIteration

  using GBIF
  using Test

  set = occurrences()

  @test iterate(set) == (set[1], 2)
  @test iterate(set, 2) == (set[2], 3)

end
