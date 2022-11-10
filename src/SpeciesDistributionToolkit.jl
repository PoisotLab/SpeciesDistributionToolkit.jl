module SpeciesDistributionToolkit

# We make ample use of re-export
using Reexport

# GBIF to get species occurrence data
@reexport using GBIF

# SimpleSDMLayers to wrap everything together
@reexport using SimpleSDMLayers

# Fauxcurrences
# @rexport using Fauxcurrences

# SimpleSDMDatasets for access to layers
@reexport using SimpleSDMDatasets

# Integrate the datasets to the layers
include("integrations/datasets_layers.jl")

# Integrate GBIF to the layers
include("integrations/gbif_layers.jl")

end # module SpeciesDistributionToolkit
