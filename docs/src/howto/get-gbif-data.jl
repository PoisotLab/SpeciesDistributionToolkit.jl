# # ... get data from GBIF?

using SpeciesDistributionToolkit
using DataFrames

# ## Identify the taxa

# The first step is to understand how GBIF represents the taxonomic information.
# The `taxon` function will take a string (or a GBIF taxonomic ID, but most people
# tend to call species by their names...) and return a representation of this
# taxon.

species = taxon("Sitta whiteheadi")

# An interesting property of the GBIF API is that it returns the full taxonomic
# information, so we can for example check the phylum of this species:

species.phylum

# ## Establish search parameters

# Now that we are fairly confident that we have the right animal, we can start
# setting up some search parameters. The search parameters are *not* given as
# keyword arguments, but as a vector of pairs (there is a reason, and it is not
# sufficiently important to spend a paragraph on at this point). We will limit our
# search to France and Italy (the species is endemic to Corsica), retrieve
# occurrences 300 at a time (the maximum allowed by the GBIF API), and only focus
# on georeferences observations. Of course, we only care about the places where
# the observations represent a *presence*, so we will use the "occurrenceStatus"
# flag to get these records only.

query = [
    "hasCoordinate" => true,
    "country" => "FR",
    "country" => "IT",
    "limit" => 300,
    "occurrenceStatus" => "PRESENT",
]

# ## Query occurrence data

# We have enough information to start our search of occurrences:

places = occurrences(species, query...)

# This step is doing a few important things. First, it is using the taxon object
# to filter the results of the API query, so that we will only get observations
# associated to this taxon. Second, it is bundling the query parameters to the
# object, so that we can modify it with subsequent requests. Internally, it is
# also keeping track of the total number of results, in order to retrieve them
# sequentially. Retrieving results sequentially is useful if you want to perform
# some operations while you collet results, for example check that you have enough
# data, and stop querying the API.

# We can count the total number of observations known to GBIF with `count`:

count(places)

# Similarly, we can count how many we actually have with `length`:

length(places)

# The package is setup so that the entire array of observations is allocated when
# we establish contact with the API for the first time, but we can only view the
# results we have actually retrieved (this is, indeed, because the records are
# exposed to the user as a `view`).

# As we know the current and total number of points, we can do a little looping to
# get all occurrences. Note that the GBIF streaming API has a hard limit at 200000
# records, and that querying this amount of data using the streaming API is
# woefully inefficient. For data volumes above 10000 observations, the suggested
# solution is to rely on the download interface on GBIF.

while length(places) < count(places)
    occurrences!(places)
end

# ## Get information on occurrence data

# When this is done, we can have a look at the countries in which the observations
# were made:

sort(unique([place.country for place in places]))

# We can also establish the time of the first and last observations:

extrema(filter(!ismissing, [place.date for place in places]))

# The GBIF results can interact very seamlessly with the layer types, which is
# covered in other vignettes.

# Finally, the package implements the interface to *Tables.jl*, so that we may
# write:

fields_to_keep = [:key, :publishingCountry, :country, :latitude, :longitude, :date]
select(DataFrame(places), fields_to_keep)[1:10,:]

# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# GBIF.taxon
# GBIF.occurrences
# GBIF.occurrences!
# ```
