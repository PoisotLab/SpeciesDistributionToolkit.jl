module TestSpecies

  using GBIF
  using Test

  iver = taxon("Iris versicolor", rank=:SPECIES)
  @test iver.species == Pair("Iris versicolor", 5298019)

  i_sp = taxon(iver.genus.first; rank=:GENUS, family=iver.family.first, strict=false)
  @test ismissing(i_sp.species)

  iver_occ = occurrences(iver)
  @test typeof(iver_occ) <: GBIFRecords
  for iocc in iver_occ
    @test iocc.taxon.species == Pair("Iris versicolor", 5298019)
  end

  iver_occ_spain = occurrences(iver, "country" => "ES")
  @test typeof(iver_occ_spain) <: GBIFRecords
  for iocc in iver_occ_spain
    @test iocc.taxon.species == Pair("Iris versicolor", 5298019)
    @test iocc.country == "Spain"
  end

end
