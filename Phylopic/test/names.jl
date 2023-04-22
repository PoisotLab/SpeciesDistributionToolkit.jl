module TestPhylopicNames

  using Phylopic
  using Test

@test typeof(Phylopic.names("homo sapiens")) == Dict{String, Base.UUID}

end
