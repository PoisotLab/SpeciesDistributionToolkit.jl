module TestSpecies

  using GBIF
  using Test

  iver = taxon("Iris versicolor", rank=:SPECIES)
  @test iver.species == Pair("Iris versicolor", 5298019)

  i_sp = taxon(iver.genus.first; rank=:GENUS, family=iver.family.first, strict=false)
  @test i_sp.species == nothing

end
