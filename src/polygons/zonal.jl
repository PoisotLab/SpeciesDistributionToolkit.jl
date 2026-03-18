"""
    zone(layer::SDMLayer, polygons::Vector{T}) where {T <: Union{Polygon,MultiPolygon,Feature,FeatureCollection}}

Returns a layer in which the value of each pixel is set to the index of the
polygon to which it belongs. Initially valued cells that are not part of a
polygon are turned off.
"""
function zone(
    layer::SDMLayer,
    polygons::Vector{T},
) where {T <: Union{Polygon, MultiPolygon, Feature, FeatureCollection}}
    out = similar(layer, Int16) # This should be enough
    fill!(out, zero(eltype(out)))
    zones = [mask!(copy(layer), poly) for poly in polygons]
    for i in eachindex(zones)
        out.grid[findall(zones[i].indices)] .= i
    end
    nodata!(out, 0)
    return out
end

zone(layer::SDMLayer, fc::FeatureCollection) = zone(layer, fc.features)

"""
    byzone(f, layer::SDMLayer, polygons, polygonsnames = 1:length(polygons))

Applies the function `f` to all cells that belong to the same polygon, and
returns the output as a dictionary. The function given as an argument can take
both positional and keyword arguments.
"""
function byzone(
    f,
    layer::SDMLayer,
    polygons::Vector{T},
    polygonsnames = 1:length(polygons),
    args...;
    kwargs...,
) where {T <: Union{Polygon, MultiPolygon, Feature, FeatureCollection}}
    z = zone(layer, polygons)
    return [
        (polygonsnames[i] => f(layer.grid[findall(z.grid .== i)], args...; kwargs...)) for
        i in unique(z)
    ]
end

"""
    byzone(f, layer::SDMLayer, fc::FeatureCollection, key, args...; kwargs...)

Applies the function `f` to all cells that belong to the same polygon, and
returns the output as a dictionary by value of `key`. The features will be
merged by their unique values of `key `.

The function given as an argument can take both positional (`args...`) and
keyword (`kwargs...`) arguments.

See also the method for `mosaic` with the same prototype, which will return a
layer with merged values.
"""
function byzone(
    f,
    layer::SDMLayer,
    fc::FeatureCollection,
    key,
    args...;
    kwargs...,
)
    if !(key in keys(uniqueproperties(fc)))
        throw(ArgumentError("The property $(key) is not part of this feature collection"))
    end
    otype =
        SimpleSDMLayers._sliding_return_type(u -> f(u, args...; kwargs...), layer, false)
    ktype = eltype(uniqueproperties(fc)[key])
    output = Dict{ktype, otype}()
    for feature in uniqueproperties(fc)[key]
        output[feature] = f(mask(layer, fc[key => feature]), args...; kwargs...)
    end
    return output
end
