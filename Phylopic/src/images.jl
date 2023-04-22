import JSON
import HTTP
import UUIDs

function images(uuid::UUIDs.UUID; format::Symbol=:png, resolution::Int=128)
    @assert format in [:png, :svg]
    @assert resolution in [64, 128, 192, 512, 1024, 1536]
    query = [
        "build" => Phylopic.buildnumber,
    ]
    req = HTTP.get(Phylopic.api * "images/$(string(uuid))", query=query)
    if isequal(200)(req.status)
        response = JSON.parse(String(req.body))
        if haskey(response, "attribution")
            @info """\n 🔓 ATTRIBUTION INFORMATION
            Licensee:\t$(response["attribution"])
            License:\t$(response["_links"]["license"]["href"])
            Credit:\tImage of $(response["_links"]["self"]["title"]) courtesy of $(response["attribution"])
            """
        end
        if isequal(:svg)(format)
            if haskey(response["_links"], "vectorFile")
                return response["_links"]["vectorFile"]["href"]
            else
                return nothing
            end
        else
            if haskey(response["_links"], "rasterFiles")
                desired_size = "$(resolution)x$(resolution)"
                right_size = filter(f -> f["sizes"] == desired_size, response["_links"]["rasterFiles"])
                img_data = isempty(right_size) ? first(response["_links"]["rasterFiles"]) : only(right_size)
                return img_data["href"]
            else
                return nothing
            end
        end
        return nothing
    end
    return nothing
end

function images(dict::Dict{String,UUIDs.UUID}; kwargs...)
    return [images(k.second; kwargs...) for k in dict]
end
