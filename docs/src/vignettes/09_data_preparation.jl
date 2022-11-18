# # Preparing data for prediction

using SpeciesDistributionToolkit
using CairoMakie

#

spatial_extent = (left = 5.0, bottom = 57.5, right = 10.0, top = 62.7)

#

rangifer = taxon("Rangifer tarandus tarandus"; strict = false)
query = [
    "occurrenceStatus" => "PRESENT",
    "hasCoordinate" => true,
    "decimalLatitude" => (spatial_extent.bottom, spatial_extent.top),
    "decimalLongitude" => (spatial_extent.left, spatial_extent.right),
    "limit" => 300,
]
presences = occurrences(rangifer, query...)
for i in 1:3
    occurrences!(presences)
end

#

dataprovider = RasterData(CHELSA1, BioClim)

varnames = layerdescriptions(dataprovider)

#

layers = [
    1.0SimpleSDMPredictor(dataprovider; spatial_extent..., layer = lname) for
    lname in ["BIO1", "BIO12"]
]

#

mutable struct SimpleSDMStack{T <: SimpleSDMLayer}
    names::Vector{String}
    layers::Vector{Base.RefValue{T}}
end

#

stack = SimpleSDMStack(["BIO1", "BIO12"], Ref.(layers))

# 

import Tables
Tables.istable(::Type{T}) where {T <: SimpleSDMStack} = true
Tables.columnaccess(::Type{T}) where {T <: SimpleSDMStack} = true
Tables.columns(s::T) where {T <: SimpleSDMStack} = s.layers
