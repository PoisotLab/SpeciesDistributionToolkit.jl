module TestPhylopicNames

using Phylopic
using Test

@test typeof(Phylopic.imagesof("chiroptera")) == Pair{String,Base.UUID}
@test typeof(Phylopic.imagesof("chiroptera"; items=2)) == Dict{String,Base.UUID}

end
