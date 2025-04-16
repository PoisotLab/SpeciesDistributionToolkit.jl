"""
    SimpleSDMLayers.mosaic(f, layer, polygons)

Overload of the mosaic function where the layer is split according to the polygons given as the last argument, and then the function `f` is applied to all the zones defined this way. The `f` function can take both positional and keyword arguments.
"""
function SimpleSDMLayers.mosaic(
    f,
    layer::SDMLayer,
    polygons::Vector{T},
    args...;
    kwargs...,
) where {T <: Union{Feature, FeatureCollection, Polygon, MultiPolygon}}
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
