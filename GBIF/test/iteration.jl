module TestIteration

  using GBIF
  using Test

  set = occurrences()

  @test iterate(set) == (set[1], 2)
  @test iterate(set, 2) == (set[2], 3)

  plotor = taxon("Procyon lotor")
  plotor_occ = occurrences(plotor)
  occurrences!(plotor_occ)
  for o in plotor_occ
      @test typeof(o) <: GBIFRecord
      @test o.taxon.species.second == plotor.species.second
  end

end
