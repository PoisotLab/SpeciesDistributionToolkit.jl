module GBIF

using HTTP
using JSON
using Dates
using Tables
import OccurrencesInterface

function safeget(endpoint)
    body = UInt8[]
    rsp = HTTP.open("GET", endpoint) do http
        while !eof(http)
            append!(body, readavailable(http))
        end
        close(HTTP.Connections.getrawstream(http))
    end
    return rsp.status, String(body)
end

const gbifurl = "http://api.gbif.org/v1/"

"""
    enumerablevalues()

Returns an *array* of values that can be enumerated by the GBIF API.
"""
function enumerablevalues()
    endpoint = GBIF.gbifurl * "enumeration/basic"
    st, bd = safeget(endpoint)
    return isequal(200)(st) ? convert(Vector{String}, JSON.parse(bd)) : nothing
end

# We load the keys that can be enumerated when we load the package
const gbifenumkeys = enumerablevalues()

"""
    enumeratedvalues(enumerable::String)

For a given enumerable value (given as a string as reported by the output of the `enumerablevalues` function), this function will return an array of possible values.
"""
function enumeratedvalues(enumerable::String)
    if enumerable in GBIF.gbifenumkeys
        endpoint = GBIF.gbifurl * "enumeration/basic/$(enumerable)"
        st, bd = safeget(endpoint)
        if isequal(200)(st)
            return convert(Vector{String}, JSON.parse(bd))
        else
            throw(ErrorException("Unable to enumerate the value $(enumerable)"))
        end
    else
        throw(
            ArgumentError(
                "$(enumerable) is not an enumerable entity for GBIF -- see GBIF.enumerablevalues()",
            ),
        )
    end
end

const gbifenums = Dict(
    "basisOfRecord" => enumeratedvalues("BasisOfRecord"),
    "occurrenceStatus" => enumeratedvalues("OccurrenceStatus"),
    "continent" => enumeratedvalues("Continent"),
    "country" => enumeratedvalues("Country"),
    "establishmentMeans" => enumeratedvalues("EstablishmentMeans"),
    "issue" => enumeratedvalues("OccurrenceIssue"),
    "mediaType" => enumeratedvalues("MediaType"),
)

include("query.jl")

include("types/GBIFTaxon.jl")
export GBIFTaxon

include("types/GBIFRecords.jl")
export GBIFRecord, GBIFRecords

include("types/iterators.jl")
include("types/show.jl")

include("taxon.jl")
export taxon

include("occurrence.jl")
include("paging.jl")
export occurrence, occurrences
export occurrences!

include("occurrencesinterface.jl")

end # module
