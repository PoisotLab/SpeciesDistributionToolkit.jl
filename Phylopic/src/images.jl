"""
    Phylopic.vector(uuid::UUIDs.UUID)

Returns the URL (if it exists) to the original vector image for the silhouette. Note that the image must be identified by its UUID, not by a string.
"""
function vector(uuid::UUIDs.UUID)
    lnks = Phylopic.images_links(uuid)
    return lnks["vectorFile"]["href"]
end

"""
    Phylopic.twitterimage(uuid::UUIDs.UUID)

Returns the twitter image for a UUID.
"""
function twitterimage(uuid::UUIDs.UUID)
    links = Phylopic.images_links(uuid)
    return links["twitter:image"]["href"]
end

"""
    Phylopic.source(uuid::UUIDs.UUID)

Returns the source image for a UUID.
"""
function source(uuid::UUIDs.UUID)
    links = Phylopic.images_links(uuid)
    return links["sourceFile"]["href"]
end

"""
    Phylopic.thumbnail(uuid::UUIDs.UUID; resolution=192)

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
twitterimage(pair::Pair{String,UUIDs.UUID}; kwargs...) = twitterimage(pair.second; kwargs...)
twitterimage(dict::Dict{String,UUIDs.UUID}; kwargs...) = twitterimage.(collect(dict); kwargs...)
source(pair::Pair{String,UUIDs.UUID}; kwargs...) = source(pair.second; kwargs...)
source(dict::Dict{String,UUIDs.UUID}; kwargs...) = source.(collect(dict); kwargs...)

"""
    Phylopic.available_resolutions(uuid::UUIDs.UUID)

Returns the available resolutions for a raster image given its UUID. The resolutions are given as a string, and can be passed as a second argument to the `Phylopic.raster` function. As the raster sizes can be different, there is no default argument to Phylopic.raster, and the first image will be used instead.
"""
function available_resolutions(uuid::UUIDs.UUID)
    lnk = Phylopic.images_links(uuid)
    resols = []
    if haskey(lnk, "rasterFiles")
        rasters = lnk["rasterFiles"]
        for raster in rasters
            push!(resols, raster["sizes"])
        end
        return resols
    end
    return nothing

end

"""
    Phylopic.raster(uuid::UUIDs.UUID, resl)

Returns the URL to an image in raster format, at the given resolution. Available resolutions for any image can be obtained with `Phylopic.available_resolutions`.
"""
function raster(uuid::UUIDs.UUID, resl)
    lnk = Phylopic.images_links(uuid)
    @assert resl in Phylopic.available_resolutions(uuid)
    if ~isnothing(lnk)
        res = filter(spec -> isequal(resl)(spec["sizes"]), lnk["rasterFiles"])
        return first(res)["href"]
    end
    return nothing
end

"""
    Phylopic.raster(uuid::UUIDs.UUID)

Returns the URL to an image in raster format when no resolution is specified. In this case, the first (usually the largest) image will be returned.
"""
function raster(uuid::UUIDs.UUID)
    lnk = Phylopic.images_links(uuid)
    if ~isnothing(lnk)
        if haskey(lnk, "rasterFiles")
            return first(lnk["rasterFiles"])["href"]
        else
            return nothing
        end
    end
    return nothing
end

available_resolutions(pair::Pair{String,UUIDs.UUID}) = available_resolutions(pair.second)
available_resolutions(dict::Dict{String,UUIDs.UUID}) = available_resolutions.(collect(dict))
raster(pair::Pair{String,UUIDs.UUID}) = raster(pair.second)
raster(dict::Dict{String,UUIDs.UUID}) = raster.(collect(dict))
raster(pair::Pair{String,UUIDs.UUID}, resl) = raster(pair.second, resl)
raster(dict::Dict{String,UUIDs.UUID}, resl) = raster.(collect(dict), resl)

function images_data(uuid::UUIDs.UUID)
    query = [
        "build" => Phylopic.build(),
    ]
    req = HTTP.get(Phylopic.api * "images/$(string(uuid))", query=query)
    if isequal(200)(req.status)
        response = JSON.parse(String(req.body))
        return response
    end
    return nothing
end

function images_links(uuid::UUIDs.UUID)
    return images_data(uuid)["_links"]
end
