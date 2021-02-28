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
    clip(layer::T, df::DataFrames.DataFrame; latitude = :latitude, longitude = :longitude) where {T <: SimpleSDMLayer}

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
    return DataFrames.DataFrame(latitude = lats, longitude = lons, values = vec(layer.grid); kw...)
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
    
    df = DataFrames.DataFrame(values; kw...)
    DataFrames.insertcols!(df, 1, :latitude => lats)
    DataFrames.insertcols!(df, 1, :longitude => lons)
    return df
end

for ty in (:SimpleSDMResponse, :SimpleSDMPredictor)
    eval(
        quote
            """
                $($ty)(df::DataFrame, col::Symbol, layer::T; latitude::Symbol = :latitude, longitude::Symbol = :longitude) where {T <: SimpleSDMLayer}

            Returns a `$($ty)` from a `DataFrame`.
            """
            function SimpleSDMLayers.$ty(df::DataFrames.DataFrame, col::Symbol, layer::SimpleSDMLayer; latitude::Symbol = :latitude, longitude::Symbol = :longitude)
                lats = df[:, latitude]
                lons = df[:, longitude]
            
                uniquelats = unique(lats)
                uniquelons = unique(lons)
            
                grid = Array{Any}(nothing, size(layer))
            
                if uniquelats == latitudes(layer) && uniquelons == longitudes(layer)
                    grid[:] = df[:, col]
                else
                    lats_idx = [SimpleSDMLayers._match_latitude(layer, lat) for lat in lats]
                    lons_idx = [SimpleSDMLayers._match_longitude(layer, lon) for lon in lons]
                    for (lat, lon, value) in zip(lats_idx, lons_idx, df[:, col])
                        grid[lat, lon] = value
                    end
                end
            
                internal_types = unique(typeof.(grid))
                return SimpleSDMLayers.$ty(Array{Union{internal_types...}}(grid), layer)
            end
        end,
    )
end

"""
    mask!(layer::SimpleSDMResponse{T}, records::DataFrames.DataFrame) where {T <: AbstractBool}

Fills a layer (most likely created with `similar`) so that the values are `true`
if an occurrence is found in the cell, `false` if not.
"""
function mask!(layer::SimpleSDMResponse{T}, df::DataFrames.DataFrame) where {T <: Bool}
    lons = df.longitude
    lats = df.latitude
    for (lon, lat) in zip(lons, lats)
        layer[lon, lat] = true
    end
    return layer
end

"""
    mask!(layer::SimpleSDMResponse{T}, records::GBIF.GBIFRecords) where {T <: Number}

Fills a layer (most likely created with `similar`) so that the values reflect
the number of occurrences in the cell.
"""
function mask!(layer::SimpleSDMResponse{T}, df::DataFrames.DataFrame) where {T <: Number}
    lons = df.longitude
    lats = df.latitude
    for (lon, lat) in zip(lons, lats)
        layer[lon, lat] = layer[lon, lat] + one(T)
    end
    return layer
end

"""
    mask(layer::SimpleSDMLayer, records::GBIF.GBIFRecords, element_type::Type=Bool)

Create a new layer storing information about the presence of occurrences in the
cells, either counting (numeric types) or presence-absence-ing (boolean types)
them.
"""
function mask(layer::SimpleSDMLayer, df::DataFrames.DataFrame, element_type::Type=Bool)
    returnlayer = similar(layer, element_type)
    mask!(returnlayer, df)
    return returnlayer
end