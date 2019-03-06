module TestSpecies

  using GBIF
  using Test

  iver = taxon("Iris versicolor", rank=:SPECIES)
  @test iver.species == Pair("Iris versicolor", 5298019)

  #iver_id = taxon(5298019, rank=:SPECIES)  #TODO COMPLETE TEST

  i_sp = taxon(iver.genus.first; rank=:GENUS, family=iver.family.first, strict=false)
  @test ismissing(i_sp.species)

  iver_occ = occurrences(iver)
  @test typeof(iver_occ) <: GBIFRecords

  iver_occ_spain = occurrences(iver, Dict{Any,Any}("country" => "ES"))
  @test typeof(iver_occ_spain) <: GBIFRecords

end
