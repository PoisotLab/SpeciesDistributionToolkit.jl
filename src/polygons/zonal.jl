"""
    zone(layer::SDMLayer, polygons)
"""
function zone(layer::SDMLayer, polygons::Vector{T}) where {T <: GeoJSON.GeoJSONT}
    out = similar(layer, Int16) # This should be enough
    fill!(out, zero(eltype(out)))
    zones = [mask!(copy(layer), poly) for poly in polygons]
    for i in eachindex(zones)
        out.grid[findall(zones[i].indices)] .= i
    end
    nodata!(out, 0)
    return out
end

"""
    byzone(f, layer::SDMLayer, polygons, polygonsnames = 1:length(polygons))
"""
function byzone(f, layer::SDMLayer, polygons::Vector{T}, polygonsnames = 1:length(polygons), args... ; kwargs...) where {T <: GeoJSON.GeoJSONT}
    z = zone(layer, polygons)
    return [
        (polygonsnames[i] => f(layer.grid[findall(z.grid .== i)], args...; kwargs...)) for
        i in unique(z)
    ]
end