module TestQAQC

  using GBIF
  using Test

  set = occurrences()

  # Use single queries
  l1 = length(set)
  filter!(have_no_issues, set)
  @test l1 >= length(set)

  # Reset queries
  showall!(set)
  @test length(set) == l1

  # Using next! and complete! after filter! should work correctly
  filter!(have_no_issues, set)
  next!(set)
  @test length(set) == 2*l1

  # Using next! and complete! after filter! should work correctly
  filter!(have_no_issues, set)
  showall!(set)
  next!(set)
  @test length(set) == 3*l1

  # Deprecation for qualitycontrol!
  # @test_warn "deprecated" qualitycontrol!(set; verbose=false)

end
