function search(catalog::Catalog; kwargs...)
    search_spec = Dict(
        :limit => Integer,
        :bbox => Vector{AbstractFloat},
        :from => DateTime,
        :to => DateTime,
        :to => DateTime,
        :intersects => String,
        :ids => Vector{String},
        :collections => Vector{Collection}
    )
    for (k, v) in kwargs
        @assert v isa search_spec[k]
    end
    query = Dict()
    for autofield in [:limit, :bbox, :intersects, :ids]
        if haskey(kwargs, autofield)
            query[autofield] = kwargs[autofield]
        end
    end
    if haskey(kwargs, :from)
        query[:date] = "$(kwargs[:from])"
    end
    if haskey(kwargs, :to)
        query[:date] *= "/$(kwargs[:to])"
    end
    if haskey(kwargs, :collections)
        query[:collections] = [c.id for c in collections]
    end
    return query
end

@testitem "We can search by collection" begin
    geobon = STACApi.Catalog("https://stac.geobon.org/")
    collec = geobon["fragmentation-rmf"]
end

