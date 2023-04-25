module Phylopic

import HTTP
import JSON
import UUIDs

const api = "https://api.phylopic.org/"

# This file contains the ping and build functions, which are only really called when the
# package is initially loaded. Ping ensures that the API responds, and build gives the value
# of the current build by default, as it is required for most operations.
include("ping.jl")

# We do a first ping to fail ASAP if the API is not responsive
@assert isnothing(Phylopic.ping())

# We put the buildnumber in a const to avoid calling it multiple times -- this is a required
# parameter for a large number of queries (most of the queries, in fact), so it makes sense
# to get it as a const ASAP
const buildnumber = Phylopic.build()
# TODO: allow an environmental variable to specify a different build version for
# reproducibility

# The autocomplete endpoint is meant to give an overview of possible names starting from
# a stem - this is not necessarilly going to give all of the names, and I am not sure why
include("autocomplete.jl")

include("imagesof.jl")
include("images.jl")

end # module hylopic
