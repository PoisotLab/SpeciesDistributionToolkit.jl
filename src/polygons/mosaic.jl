"""
    SimpleSDMLayers.mosaic(f, layer, polygons)
"""
function SimpleSDMLayers.mosaic(f, layer::SDMLayer, polygons)
    rtype = eltype(f(layer))
    out = zeros(layer, rtype)
    zones = [mask!(copy(layer), poly) for poly in polygons]
    for i in eachindex(zones)
        if ~isempty(zones[i])
            out.grid[findall(zones[i].indices)] .= f(zones[i])
        end
    end
    return out
end
