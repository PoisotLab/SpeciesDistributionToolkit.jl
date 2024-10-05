module OccurrencesInterface

using Dates
using TestItems

include("types.jl")
export AbstractOccurrence, AbstractOccurrenceCollection
export Occurrence, Occurrences

include("interface.jl")
export elements
export entity, place, date, presence
export presences, absences

end # module OccurrencesInterface
