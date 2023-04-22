module TestPhylopicPing

  using Phylopic
  using Test

@test isnothing(Phylopic.ping())

end
