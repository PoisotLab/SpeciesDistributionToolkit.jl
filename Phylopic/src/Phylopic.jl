module Phylopic

import HTTP
import JSON
using UUIDs

const api = "https://api.phylopic.org/"

include(joinpath(pwd(), "src", "ping.jl"))

# We do a first ping to fail asap
@assert isnothing(Phylopic.ping())

# We put the buildnumber in a const to avoid calling it multiple times
const buildnumber = Phylopic.build()

include(joinpath(pwd(), "src", "autocomplete.jl"))
include(joinpath(pwd(), "src", "images.jl"))

end # module Phylopic
