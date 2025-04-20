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

"""
    Phylopic.attribution(ps::PhylopicSilhouette)

Generates a string for the attribution of an image. This string is
markdown-formatted, and will include a link to the license. When given a vector
of silhouettes, a _single_ markdown block is returned.
"""
attribution(ps::PhylopicSilhouette; kwargs...) = attribution(ps.id; kwargs...)
attribution(vps::Vector{PhylopicSilhouette}; kwargs...) = Markdown.parse(join(attribution.(vps; kwargs...), "   \n"))