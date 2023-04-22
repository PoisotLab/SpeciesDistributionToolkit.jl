module Phylopic

import HTTP
import JSON
using UUIDs

const api = "https://api.phylopic.org/"

include(joinpath(pwd(), "src", "ping.jl"))

# We do a first ping to fail ASAP if the API is not responsive
@assert isnothing(Phylopic.ping())

# We put the buildnumber in a const to avoid calling it multiple times -- this is a required
# parameter for a large number of queries (most of the queries, in fact), so it makes sense
# to get it as a const ASAP
const buildnumber = Phylopic.build()

# the autocomplete endpoint is meant to give an overview of possible names starting from
# a stem
include(joinpath(pwd(), "src", "autocomplete.jl"))

# the images endpoint does a lot of different things, which is very confusing but that's the
# way the API is built. When given search parameters, it gives back a range of pages. When
# given a page, it gives a list of items. When given an UUID, it gives the links to all of
# the versions of an image.
include(joinpath(pwd(), "src", "images.jl"))

end # module Phylopic
