module TestSpecies

  using GBIF
  using Base.Test

  iver = taxon("Iris versicolor", rank=:SPECIES)

  @test iver["canonicalName"] == "Iris versicolor"

end
