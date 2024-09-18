function zone(layer::SDMLayer, polygons)
    out = similar(layer, Int16) # This should be enough
    fill!(out, zero(eltype(out)))
    zones = [mask!(copy(layer), poly) for poly in polygons]
    for i in eachindex(zones)
        out.grid[findall(zones[i].indices)] .= i
    end
    nodata!(out, 0)
    return out
end

function byzone(f, layer::SDMLayer, polygons, polygonsnames = 1:length(polygons))
    z = zone(layer, polygons)
    return [
        (polygonsnames[i] => f(layer.grid[findall(z.grid .== i)])) for
        i in eachindex(polygons)
    ]
end