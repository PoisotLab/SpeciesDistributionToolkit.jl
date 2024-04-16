module Phylopic

import HTTP
import JSON
import UUIDs
using Markdown

const api = "https://api.phylopic.org/"

# This file contains the ping and build functions, which are only really called when the
# package is initially loaded. Ping ensures that the API responds, and build gives the value
# of the current build by default, as it is required for most operations.
include("ping.jl")

function __init__()
    # We do a first ping to fail ASAP if the API is not responsive
    @assert isnothing(Phylopic.ping())
    # We put the buildnumber in a package-level variable
    Phylopic.buildnumber = Phylopic.build()
    return nothing
end

# The autocomplete endpoint is meant to give an overview of possible names starting from
# a stem - this is not necessarilly going to give all of the names, and I am not sure why
include("autocomplete.jl")

include("imagesof.jl")
include("images.jl")
include("attribution.jl")

end # module Phylopic
