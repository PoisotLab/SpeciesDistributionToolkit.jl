module TestOccurrencesInterface

using Test
using GBIF
using GBIF.OccurrencesInterface

set = occurrences("hasCoordinate" => true, "occurrenceStatus" => "ABSENT")
@test all(!, presence(set))

set = occurrences("hasCoordinate" => true, "occurrenceStatus" => "PRESENT")
@test all(presence(set))

@test eltype(place(set)) == Tuple{Float64,Float64}

@test length(presences(set).records) == length(set)

end
