# # ... download data from GBIF?

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# Get occ data

occ = GBIF.download("10.15468/dl.ttnmj9")

# list taxa found

# get only raccoons

# make plot

# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# GBIF.taxon
# GBIF.occurrences
# GBIF.occurrences!
# ```
