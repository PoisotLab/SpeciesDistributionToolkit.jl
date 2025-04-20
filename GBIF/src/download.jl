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
        throw(
            ErrorException(
                "The GBIF username is missing - see the documentation for GBIF.username!",
            ),
        )
    end
    if ismissing(passwd)
        throw(
            ErrorException(
                "The GBIF password is missing - see the documentation for GBIF.password!",
            ),
        )
    end
    temp = "Basic " * Base64.base64encode("$(uname):$(passwd)")
    auth = Dict("Authorization" => temp)
    return auth
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

"""
    download

Prepares a request for a download through the GBIF API
"""
function request(query::Pair...; notification::Bool = false)
    # Get the predicates
    predicates = GBIF._predicate(query...)
    if notification
        predicates["sendNotification"] = true
        push!(predicates["notificationAddresses"], GBIF.email())
    end
    # Make the request
    request_url = GBIF.gbifurl * "occurrence/download/request"
    @info request_url
    request_resp = HTTP.post(request_url; body = predicates, headers = GBIF.apiauth())
    @info request_resp
    return nothing
end

"""
    download(key)

Downloads the zip file associated to a specific query (identified by its key) as
a zip file. Note that if you do not know the dataset key, this function also
accepts the DOI. For now, the results are returned as `Occurrences` as opposed
to `GBIFRecords`. This will be modifiable in a future release.
"""
function download(key)
    if contains(key, "/dl.")
        key = GBIF.doi(key)["key"]
    end
    request_url = GBIF.gbifurl * "occurrence/download/request/$(key)"
    dl_req = HTTP.get(request_url)#; headers=GBIF.apiauth())
    if dl_req.status == 200
        # Get that bag
        open("$(key).zip", "w") do f
            write(f, dl_req.body)
        end
        archive = "$(key).zip"
        csv = CSV.File(GBIF._get_csv_from_zip(archive))
        return OccurrencesInterface.Occurrences(GBIF._materialize.(OccurrencesInterface.Occurrence, csv))
    end
end

function _materialize(::Type{OccurrencesInterface.Occurrence}, row::CSV.Row)
    date = missing
    if !ismissing(row.eventDate)
        try
            date = Dates.DateTime(replace(row.eventDate, "Z" => ""))
        catch
            @info "Malformed date for record $(row.gbifID) - date will be missing"
        end
    end
    place = ismissing(row.decimalLatitude)|ismissing(row.decimalLongitude) ? missing : (row.decimalLongitude, row.decimalLatitude)
    whatis = ismissing(row.verbatimScientificName) ? row.scientificName : row.verbatimScientificName
    return OccurrencesInterface.Occurrence(
        presence = row.occurrenceStatus == "PRESENT",
        what = whatis,
        when = date,
        where = place
    )
end

function mydownloads(; preparing=true, running=true, succeeded=true, cancelled=true, killed=true, failed=true, suspended=true, erased=true)
    statuses = String[]
    preparing && push!(statuses, "PREPARING")
    running && push!(statuses, "RUNNING")
    succeeded && push!(statuses, "SUCCEEDED")
    cancelled && push!(statuses, "CANCELLED")
    killed && push!(statuses, "KILLED")
    failed && push!(statuses, "FAILED")
    suspended && push!(statuses, "SUSPENDED")
    erased && push!(statuses, "FILE_ERASED")
    # Get the predicates
    request_url = GBIF.gbifurl * "occurrence/download/user/$(GBIF.username())"
    request_resp = HTTP.get(request_url; query="status=$(join(statuses, ','))", headers = GBIF.apiauth())
    if request_resp.status == 200
        return JSON.parse(String(request_resp.body))
    end
end

"""
   doi(doi::String)

Returns the information of a download request by its DOI.
"""
function doi(doi::String)
    request_url = GBIF.gbifurl * "occurrence/download/$doi"
    request_resp = HTTP.get(request_url)#; headers = GBIF.apiauth())
    if request_resp.status == 200
        return JSON.parse(String(request_resp.body))
    end
end

function _get_csv_from_zip(archive)
    zip_archive = ZipArchives.ZipReader(read(archive))
    for file_in_zip in ZipArchives.zip_names(zip_archive)
        if file_in_zip == replace(archive, ".zip" => ".csv")
            out = open(file_in_zip, "w")
            write(out, ZipArchives.zip_readentry(zip_archive, file_in_zip, String))
            close(out)
        end
    end
    return replace(archive, ".zip" => ".csv")
end