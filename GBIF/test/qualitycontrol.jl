module TestQAQC

  using GBIF
  using Base.Test

  set = occurrences()
  qualitycontrol!(set)

  @test set.cleaned
  @test_warn "A filtered list of occurences cannot be resumed - object unchanged" next!(set)
  @test_warn "A filtered list of occurences cannot be resumed - object unchanged" complete!(set)

  restart!(set)
  @test set.cleaned == false

end
