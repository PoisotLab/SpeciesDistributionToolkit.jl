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

"""
    SimpleSDMLayers.mosaic(f, layer, fc, key, args...; kwargs...)

Overload of the mosaic function where the layer is split according to the
polygons given as the last argument, and then the function `f` is applied to all
the zones defined this way. The `f` function can take both positional and
keyword arguments.
"""
function SimpleSDMLayers.mosaic(
    f,
    layer::SDMLayer,
    fc::FeatureCollection,
    key,
    args...;
    kwargs...,
)
    otype =
        SimpleSDMLayers._sliding_return_type(u -> f(u, args...; kwargs...), layer, false)
    output = similar(layer, otype)
    mask!(output, fc)
    for feature in uniqueproperties(fc)[key]
        masked_layer = mask(layer, fc[key => feature])
        if !isempty(masked_layer)
            masked_val = f(masked_layer, args...; kwargs...)
            output.grid[findall(masked_layer.indices)] .= masked_val
        end
    end
    return output
end