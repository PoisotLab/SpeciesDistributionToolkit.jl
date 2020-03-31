module TestQAQC

  using GBIF
  using Test

  set = occurrences()

  # Use single queries
  l1 = length(set)
  filter!(have_no_issues, set)
  @test l1 >= length(set)

  # Reset queries
  allrecords!(set)
  @test length(set) == l1

  # Using occurrences! after filter! should work correctly
  filter!(have_no_issues, set)
  occurrences!(set)
  @test length(set) == 2*l1

  # Using next! and complete! after filter! should work correctly
  filter!(have_no_issues, set)
  allrecords!(set)
  occurrences!(set)
  @test length(set) == 3*l1

  # Multiple filters at once
  allrecords!(set)
  filter!.([have_ok_coordinates, have_a_date], set)
  allrecords!(set)
  filter!.([have_neither_zero_coordinates, have_a_date], set)
  allrecords!(set)
  filter!.([have_neither_zero_coordinates, have_a_date], set)
  @test length(set) != 3*l1

end
