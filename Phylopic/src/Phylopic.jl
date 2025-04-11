module Phylopic

import HTTP
import JSON
import UUIDs
using Markdown

using TestItems

const api = "https://api.phylopic.org/"

# This file contains the ping and build functions, which are only really called when the
# package is initially loaded. Ping ensures that the API responds, and build gives the value
# of the current build by default, as it is required for most operations.
include("ping.jl")

# The autocomplete endpoint is meant to give an overview of possible names starting from
# a stem - this is not necessarilly going to give all of the names, and I am not sure why
include("autocomplete.jl")

include("Silhouette.jl")
export PhylopicSilhouette

include("imagesof.jl")

include("images.jl")
include("attribution.jl")

# Required for plotting

import FileIO
import Downloads
function _get_silhimg(ps)
    f = Downloads.download(Phylopic.thumbnail(ps))
    return FileIO.load(f)
end

end # module Phylopic
