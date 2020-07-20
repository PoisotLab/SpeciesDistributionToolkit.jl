# WARNING this file is only loaded if DataFrames.jl is also active
# This all happens thanks to the Requires.jl package

import Base: getindex
import Base: setindex!
import SimpleSDMLayers: clip, latitudes, longitudes

"""
    Base.getindex(layer::T, df::DataFrames.DataFrame; latitude = :latitude, longitude = :longitude) where {T <: SimpleSDMLayer}

Returns the values of a layer at all occurrences in a `DataFrame`.
"""
function Base.getindex(layer::T, df::DataFrames.DataFrame; latitude = :latitude, longitude = :longitude) where {T <: SimpleSDMLayer}
    lats = df[:, latitude]
    lons = df[:, longitude]
    return [layer[lon, lat] for (lon, lat) in zip(lons, lats)]
end

"""
    function clip(layer::T, df::DataFrames.DataFrame; latitude = :latitude, longitude = :longitude) where {T <: SimpleSDMLayer}

Returns a clipped version (with a 10% margin) around all occurences in a
`DataFrame`.
"""
function SimpleSDMLayers.clip(layer::T, df::DataFrames.DataFrame; latitude = :latitude, longitude = :longitude) where {T <: SimpleSDMLayer}
   occ_latitudes = filter(!ismissing, df[:, latitude])
   occ_longitudes = filter(!ismissing, df[:, longitude])

   lat_min = minimum(occ_latitudes)
   lat_max = maximum(occ_latitudes)
   lon_min = minimum(occ_longitudes)
   lon_max = maximum(occ_longitudes)

   lat_Δ = abs(lat_max - lat_min)
   lon_Δ = abs(lon_max - lon_min)

   scaling = 0.1
   lon_s = scaling*lon_Δ
   lat_s = scaling*lat_Δ

   lat_max = min(layer.top, lat_max+lat_s)
   lat_min = max(layer.bottom, lat_min-lat_s)
   lon_max = min(layer.right, lon_max+lon_s)
   lon_min = max(layer.left, lon_min-lon_s)

   return layer[left=lon_min, right=lon_max, bottom=lat_min, top=lat_max]
end

"""
    DataFrames.DataFrame(layer::T) where {T <: SimpleSDMLayer}

Returns a DataFrame from a `SimpleSDMLayer` element, with columns for latitudes,
longitudes and grid values.
"""
function DataFrames.DataFrame(layer::T; kw...) where {T <: SimpleSDMLayer}
    lats = repeat(latitudes(layer), outer = size(layer, 2))
    lons = repeat(longitudes(layer), inner = size(layer, 1))
    return DataFrames.DataFrame(latitude = lats, longitudes = lons, values = vec(layer.grid); kw...)
end

"""
    DataFrames.DataFrame(layers::Array{SimpleSDMLayer})

Returns a single DataFrame from an `Array` of compatible`SimpleSDMLayer`
elements, with every layer as a column, as well as columns for latitudes and longitudes.
"""
function DataFrames.DataFrame(layers::Array{T}; kw...) where {T <: SimpleSDMLayer}
    l1 = layers[1]
    all(x -> SimpleSDMLayers._layers_are_compatible(x, l1), layers)
    
    lats = repeat(latitudes(l1), outer = size(l1, 2))
    lons = repeat(longitudes(l1), inner = size(l1, 1))
    values = mapreduce(x -> vec(x.grid), hcat, layers)
    
    df = DataFrames.DataFrame(hcat(lats, lons, values); kw...)
    DataFrames.rename!(df, [:latitude, :longitude, Symbol.("x", eachindex(layers))...])
    return df
end