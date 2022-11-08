module SpeciesDistributionsToolkit

# We make ample use of re-export
using Reexport

# GBIF to get species occurrence data
@reexport using GBIF

# SimpleSDMLayers to wrap everything together
@reexport using SimpleSDMLayers

# Faucurrences
@reexport using Fauxcurrences

# SimpleSDMDatasets for access to layers
@reexport using SimpleSDMDatasets

# Additional functions provided by the package
include("integrations/gbif_layers.jl")

end # module SpeciesDistributionsToolkit
