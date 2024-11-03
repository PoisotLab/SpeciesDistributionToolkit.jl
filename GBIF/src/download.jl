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
    mydownloads()

Returns the downloads associated to the currently authenticated user.
"""
function mydownloads()
    ismissing(GBIF.username()) && throw(ErrorException("Use GBIF.username! to login"))
    ismissing(GBIF.email()) && throw(ErrorException("Use GBIF.email! to login"))

end

"""
    download

Prepares a request for a download through the GBIF API
"""
function download(query::Pair...)
    ismissing(GBIF.username()) && throw(ErrorException("Use GBIF.username! to login"))
    ismissing(GBIF.email()) && throw(ErrorException("Use GBIF.email! to login"))
    # Get the predicates
    pred = GBIF.predicate(query...)
    # 
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
    pre_s_req = HTTP.get(predicate_url; query=querystring)
    if pre_s_req.status == 200
        return JSON.parse(String(pre_s_req.body))
    end
end
