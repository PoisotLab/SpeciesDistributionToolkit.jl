"""
    Phylopic.attribution(uuid::UUIDs.UUID)

Generates a string for the attribution of an image, as identified by its `uuid`. This string is markdown-formatted, and will include a link to the license.
"""
function attribution(uuid::UUIDs.UUID)
    data = Phylopic.images_data(uuid)
    contributorname = data["attribution"]
    nodename = data["_links"]["specificNode"]["title"]
    license = data["_links"]["license"]["href"]
    attr_string = "Image of *$(nodename)* provided by [$(contributorname)]($license)"
    return Markdown.parse(attr_string)
end

attribution(pair::Pair{String,UUIDs.UUID}; kwargs...) = attribution(pair.second; kwargs...)
attribution(dict::Dict{String,UUIDs.UUID}; kwargs...) = attribution.(collect(dict); kwargs...)

attribution(ps::PhylopicSilhouette; kwargs...) = attribution(ps.id; kwargs...)
attribution(vps::Vector{PhylopicSilhouette}; kwargs...) = Markdown.parse(join(attribution.(vps; kwargs...), "   \n"))