"""
    Phylopic.vector(uuid::UUIDS.UUID)

Returns the URL (if it exists) to the original vector image for the silhouette. Note that the image must be identified by its UUID, not by a string.
"""
function vector(uuid::UUIDs.UUID)
    lnks = Phylopic.images_links(uuid)
    return lnks["vectorFile"]["href"]
end

"""
    Phylopic.thumbnail(uuid::UUIDS.UUID; resolution=192)

Returns the URL (if it exists) to the thumbnails for the silhouette. The thumbnail `resolution` can be `64`, `128`, or `192` (the default).
"""
function thumbnail(uuid::UUIDs.UUID; resolution=192)
    @assert resolution in [64, 128, 192]
    lnks = Phylopic.images_links(uuid)
    required_size = "$(resolution)x$(resolution)"
    img = filter(f -> f["sizes"] == required_size, lnks["thumbnailFiles"])
    return only(img)["href"]
end

thumbnail(pair::Pair{String,UUIDs.UUID}; kwargs...) = thumbnail(pair.second; kwargs...)
thumbnail(dict::Dict{String,UUIDs.UUID}; kwargs...) = thumbnail.(collect(dict); kwargs...)
vector(pair::Pair{String,UUIDs.UUID}; kwargs...) = vector(pair.second; kwargs...)
vector(dict::Dict{String,UUIDs.UUID}; kwargs...) = vector.(collect(dict); kwargs...)

function images_links(uuid::UUIDs.UUID; format::Symbol=:png, resolution::Int=128)
    @assert format in [:png, :svg]
    @assert resolution in [64, 128, 192, 512, 1024, 1536]
    query = [
        "build" => Phylopic.buildnumber,
    ]
    req = HTTP.get(Phylopic.api * "images/$(string(uuid))", query=query)
    if isequal(200)(req.status)
        response = JSON.parse(String(req.body))
        return response["_links"]
    end
    return nothing
end

