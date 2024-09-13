module STACApi

import HTTP
import JSON3
using Dates
using TestItems

function __handle_get_response(req)
    if isequal(200)(req.status)
        output = JSON3.read(req.body)
        return output
    else
        output = JSON3.read(req.body)
        throw(ErrorException(output["description"]))
    end
    return nothing
end

include("core.jl")
include("collections.jl")
include("features.jl")

# https://stac.geobon.org/ for testing

end
