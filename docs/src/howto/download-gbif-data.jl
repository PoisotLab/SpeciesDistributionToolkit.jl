# # ... download data from GBIF?

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# The correct way to consume a large amount of GBIF data is to get them through
# the download mechanism, in particular to ensure that the data contributors can
# be cited. We will get a downloaded dataset by using its DOI:

occ = GBIF.download("10.15468/dl.ttnmj9")

# The occurrences are returned as an `Occurrences` object from the
# `OccurrencesInterface` package. Note that the GBIF file is also downloaded to
# the directory from which the script is being called, so you can inspect the
# raw data.

# We will get the list of unique taxa contained within this data download:

tax = unique(entity(occ));

# We will make a map with the number of observations for *Procyon lotor*:

# fig-map
coast = getpolygon(PolygonData(NaturalEarth, Land))
bbox = SpeciesDistributionToolkit.boundingbox(occ; padding=3.0)
fig = Figure()
ax = Axis(fig[1,1], aspect=DataAspect())
poly!(ax, coast, color=:lightgrey)
xlims!(ax, bbox.left, bbox.right)
ylims!(ax, bbox.bottom, bbox.top)
hexbin!(ax, filter(o -> startswith("Procyon lotor")(entity(o)), elements(occ)), bins=300, colormap=:linear_worb_100_25_c53_n256, colorscale=log10)
lines!(ax, coast, color=:grey)
current_figure() #hide

# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# OccurrencesInterface.Occurrence
# OccurrencesInterface.Occurrences
# OccurrencesInterface.entity
# ```
