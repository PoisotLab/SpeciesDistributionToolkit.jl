username() = get(ENV, "GBIF_USERNAME", missing)
email() = get(ENV, "GBIF_EMAIL", missing)
password() = get(ENV, "GBIF_PASSWORD", missing)

function username!(un::String)
    ENV["GBIF_USERNAME"] = un
    return GBIF.username()
end

function email!(em::String)
    ENV["GBIF_EMAIL"] = em
    return GBIF.email()
end

function password!(pw::String)
    ENV["GBIF_PASSWORD"] = pw
    return GBIF.password()
end

"""
Returns a dict to be used as part of the headers for HTTP functions to do
authentication against the download API. This returns a dictionary that is used
internally by calls to endpoints for the download API.
"""
function apiauth()
    uname = GBIF.username()
    passwd = GBIF.password()
    if ismissing(uname)
        throw(ErrorException("The GBIF username is missing - see the documentation for GBIF.username!"))
    end
    if ismissing(passwd)
        throw(ErrorException("The GBIF password is missing - see the documentation for GBIF.password!"))
    end
    temp = "Basic " * Base64.base64encode("$(uname):$(passwd)")
    auth = Dict("Authorization" => temp)
    return auth
end

"""
    download

Prepares a request for a download through the GBIF API
"""
function download(query::Pair...; notification::Bool=false)
    # Get the predicates
    predicates = GBIF._predicate(query...)
    if notification
        predicates["sendNotification"] = true
        push!(predicates["notificationAddresses"], GBIF.email())
    end
    #
    return nothing 
end

"""
    _predicate(query::Pair...)

Given the arguments that are accepted by GBIF.occurrences, returns the
corresponding predicates for the download API.
"""
function _predicate(query::Pair...)
    query = (query..., "format" => "simpleCsv")
    querystring = pairs_to_querystring(query...)
    predicate_url = GBIF.gbifurl * "occurrence/download/request/predicate"
    pre_s_req = HTTP.get(predicate_url; query = querystring, headers = GBIF.apiauth())
    if pre_s_req.status == 200
        return JSON.parse(String(pre_s_req.body))
    end
end
