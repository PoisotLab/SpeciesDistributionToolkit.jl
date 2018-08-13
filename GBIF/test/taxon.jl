module TestSpecies

  using GBIF
  using Test

  iver = taxon("Iris versicolor", rank=:SPECIES)
  @test iver.species == Pair("Iris versicolor", 5298019)

  i_sp = taxon(iver.genus.first; rank=:GENUS, family=iver.family.first, strict=false)
  @test i_sp.species == nothing

  iver_occ = occurrences(iver)
  @test typeof(iver_occ) <: GBIFRecords

  iver_occ_spain = occurrences(iver, Dict{Any,Any}("country" => "ES"))
  @test typeof(iver_occ_spain) <: GBIFRecords

end
