# # Preparing data for prediction

using SpeciesDistributionToolkit

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
    convert(
        SimpleSDMResponse,
        1.0SimpleSDMPredictor(dataprovider; spatial_extent..., layer = lname),
    ) for
    lname in ["BIO1", "BIO12"]
]

# 

presenceonly = mask(layers[1], presences, Bool)
absenceonly = SpeciesDistributionToolkit.sample(
    pseudoabsencemask(SurfaceRangeEnvelope, presenceonly),
    250,
)
replace!(presenceonly, false => nothing)
replace!(absenceonly, false => nothing)
for cell in absenceonly
    presenceonly[cell.longitude, cell.latitude] = false
end

for i in eachindex(layers)
    keys_to_void = setdiff(keys(layers[i]), keys(presenceonly))
    for k in keys_to_void
        layers[i][k] = nothing
    end
end

layers

#

refs = Ref.([layers..., presenceonly])

datastack = SimpleSDMStack(["BIO1", "BIO12", "Presence"], refs)

# 

import Tables
Tables.istable(::Type{SimpleSDMStack}) = true
Tables.rowaccess(::Type{SimpleSDMStack}) = true
function Tables.schema(s::SimpleSDMStack)
    tp = first(s)
    @info keys(tp)
    sc = Tables.Schema(keys(tp), typeof.(values(tp)))
    @info sc
    return sc
end

using DataFrames
DataFrame(datastack)

#

using MLJ

# 

t = table(datastack)
