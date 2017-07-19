module TestSpecies

  using GBIF
  using Base.Test

  iver = species("Iris versicolor", rank=:SPECIES)

  @test iver["canonicalName"] == "Iris versicolor"

end
