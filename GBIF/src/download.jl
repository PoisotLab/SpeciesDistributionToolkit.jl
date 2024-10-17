username() = get(ENV, "GBIF_USERNAME", missing)
email() = get(ENV, "GBIF_EMAIL", missing)

function username!(un::String)
    ENV["GBIF_USERNAME"] = un
    return GBIF.username()
end

function email!(em::String)
    ENV["GBIF_EMAIL"] = em
    return GBIF.email()
end

"""
    download

Prepares a request for a download through the GBIF API
"""
function download(query::Pair...)
    isempty(GBIF.username()) && throw(ErrorException("Use GBIF.username! to login"))
    isempty(GBIF.email()) && throw(ErrorException("Use GBIF.email! to login"))
end

function _predicate(query::Pair...)
    querystring = pairs_to_querystring(query...) 
    predicate_url = GBIF.gbifurl * "occurrence/download/request/predicate/"
    pre_s_req = HTTP.get(predicate_url; query=querystring
    if pre_s_req.status == 200
        return JSON.parse(String(pre_s_req.body))
    end
end
