module Phylopic

import HTTP
import JSON
using UUIDs

const api = "https://api.phylopic.org/"

include(joinpath(pwd(), "src", "ping.jl"))
include(joinpath(pwd(), "src", "autocomplete.jl"))
include(joinpath(pwd(), "src", "images.jl"))

end # module Phylopic
