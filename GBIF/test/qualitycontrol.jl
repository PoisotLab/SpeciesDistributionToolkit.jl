module TestQAQC

  using GBIF
  using Base.Test

  set = occurrences()
  qualitycontrol!(set)

end
