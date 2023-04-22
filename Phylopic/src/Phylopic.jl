module Phylopic

import HTTP
import JSON

const api = "https://api.phylopic.org/"

function ping()
    req = HTTP.get(api * "ping")
    if req.status == 204
        return nothing
    else
        throw(ErrorException("The API at $(api) is not responding"))
    end
    return nothing
end

end # module Phylopic
