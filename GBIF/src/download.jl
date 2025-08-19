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
    download(key; path=nothing)

Download the GBIF occurrence download archive for the given `key` (or DOI), extract and
return the parsed records as `Occurrences`. The `key` (`AbstractString`) is a GBIF
download key such as `"0012345-240613123456789"`, or a DOI such as `"10.15468/dl.abcd12"`.
If a DOI is provided, it is first resolved to the corresponding GBIF download key.

The `path` keyword (defaults to `nothing`) can be used to specify where the
files will be downloaded. The default is the working directory. If the `path`
does not exist, it will be created using `mkpath`. The intended use-case is to
put the downloaded files in a git-ignored folder.
"""
function download(key::AbstractString; path=nothing)
    # If this is a DOI, we start by getting the correct key
    if contains(key, "/dl.")
        key = GBIF.doi(key)["key"]
    end
    # If the files go in a specific path, we will handle this here, by creating
    # the path if it does not exist, and by making sure this path is added to
    # the archive.
    archive = isnothing(path) ? "$(key).zip" : joinpath(path, "$(key).zip")
    if !ispath(dirname(archive))
        mkpath(dirname(archive))
    end
    request_url = GBIF.gbifurl * "occurrence/download/request/$(key)"
    dl_req = HTTP.get(request_url)
    if dl_req.status == 200
        open(archive, "w") do f
            return write(f, dl_req.body)
        end
        csv = CSV.File(GBIF._get_csv_from_zip(archive); delim = '\t')
        return OccurrencesInterface.Occurrences(
            GBIF._materialize.(OccurrencesInterface.Occurrence, csv),
        )
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
    place = if ismissing(row.decimalLatitude) | ismissing(row.decimalLongitude)
        missing
    else
        (row.decimalLongitude, row.decimalLatitude)
    end
    whatis = if !ismissing(row.scientificName)
        row.scientificName
    elseif !ismissing(row.verbatimScienceName)
        row.verbatimScientificName
    else
        "Unknown taxon"
    end
    return OccurrencesInterface.Occurrence(;
        presence = row.occurrenceStatus == "PRESENT",
        what = whatis,
        when = date,
        where = place,
    )
end

function mydownloads(;
    preparing = true,
    running = true,
    succeeded = true,
    cancelled = true,
    killed = true,
    failed = true,
    suspended = true,
    erased = true,
)
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
    request_resp = HTTP.get(
        request_url;
        query = "status=$(join(statuses, ','))",
        headers = GBIF.apiauth(),
    )
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
    csvfile = replace(archive, ".zip" => ".csv")
    for file_in_zip in ZipArchives.zip_names(zip_archive)
        if file_in_zip == csvfile
            out = open(csvfile, "w")
            write(out, ZipArchives.zip_readentry(zip_archive, file_in_zip, String))
            close(out)
        end
    end
    return csvfile
end

