module TestQAQC

  using GBIF
  using Test

  set = occurrences()
  qualitycontrol!(set)

end
