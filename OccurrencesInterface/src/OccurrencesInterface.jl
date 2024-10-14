module OccurrencesInterface

using Dates
using TestItems
using Tables

include("types.jl")
export AbstractOccurrence, AbstractOccurrenceCollection
export Occurrence, Occurrences

include("interface.jl")
export elements
export entity, place, date, presence
export presences, absences

include("tables.jl")

end # module OccurrencesInterface
