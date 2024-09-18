"""
    SimpleSDMLayers.mosaic(f, layer, polygons)
"""
function SimpleSDMLayers.mosaic(f, layer::SDMLayer, polygons::Vector{T}, args...; kwargs...) where {T <: GeoJSON.GeoJSONT}
    rtype = eltype(f(layer, args...; kwargs...))
    out = zeros(layer, rtype)
    zones = [mask!(copy(layer), poly) for poly in polygons]
    for i in eachindex(zones)
        if ~isempty(zones[i])
            out.grid[findall(zones[i].indices)] .= f(zones[i], args...; kwargs...)
        end
    end
    return out
end
