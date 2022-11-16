# # Generating background points

# In this vignette, we will generate some background points (pseudo-absences) using the
# different algorithms present in the package.

using SpeciesDistributionToolkit
using CairoMakie

#

spatial_extent = (left = 3.032, bottom = 55.178, right = 19.687, top = 64.717)

# 

rangifer = taxon("Rangifer tarandus tarandus"; strict = false)
query = [
    "occurrenceStatus" => "PRESENT",
    "hasCoordinate" => true,
    "country" => "NO",
    "country" => "SE",
    "country" => "FI",
    "country" => "DE",
    "limit" => 300,
]
presences = occurrences(rangifer, query...)
while length(presences) < 3000
    occurrences!(presences)
end

# 

dataprovider = RasterData(CHELSA1, BioClim)
temperature = 0.1SimpleSDMPredictor(dataprovider; layer = "BIO1", spatial_extent...)

# 

presence_only = mask(temperature, presences, Bool)

# 

heatmap(sprinkle(presence_only)...)

# get a pseudo-absence

background = similar(presence_only, Bool)

# generate 200 pseudo-absences

for i in 1:2000
    pa = pseudoabsence(WithinRadius, presence_only; distance = 100.0)
    background[pa] = true
end

# 

heatmap(sprinkle(background)...)

scatter!(longitudes(presences), latitudes(presences))
