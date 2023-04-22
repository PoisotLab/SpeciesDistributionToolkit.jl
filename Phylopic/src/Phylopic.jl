module Phylopic

import HTTP
import JSON
using UUIDs

const api = "https://api.phylopic.org/"

include("ping.jl")

# We do a first ping to fail ASAP if the API is not responsive
@assert isnothing(Phylopic.ping())

# We put the buildnumber in a const to avoid calling it multiple times -- this is a required
# parameter for a large number of queries (most of the queries, in fact), so it makes sense
# to get it as a const ASAP
const buildnumber = Phylopic.build()

# the autocomplete endpoint is meant to give an overview of possible names starting from
# a stem - this is not necessarilly going to give all of the names, and I am not sure why
include("autocomplete.jl")

include("names.jl")
include("images.jl")

end # module hylopic
