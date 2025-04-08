module OccurrencesInterface

using Dates
using TestItems
using Tables
import JSON

include("types.jl")
export AbstractOccurrence, AbstractOccurrenceCollection
export Occurrence, Occurrences

include("interface.jl")
export elements
export entity, place, date, presence
export presences, absences

include("tables.jl")

include("indexing.jl")

include("io.jl")

include("demodata.jl")

end # module OccurrencesInterface
