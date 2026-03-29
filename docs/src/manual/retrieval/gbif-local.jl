# # Reading local GBIF data

using SpeciesDistributionToolkit
using CairoMakie

# In addition to [downloading GBIF data](/manual/retrieval/gbif-download/), we
# can work with locally downloaded GBIF files in either Darwin Core or Simple
# formats. 

GBIF.download("0069567-260226173443078") #hide

# In this example, we will get data from a local copy of [this GBIF data
# download](https://doi.org/10.15468/dl.y8d8yb ), which aggregates known
# occurrenes of _Cardinalis cardinalis_ in the country of Belize.

records = GBIF.localarchive("0069567-260226173443078.zip")

# Because the function to read from local archives is what makes the `download`
# function work internally, the options are the same. Both functions can take a
# second argument that is a type, allowing to export the occurrences to a
# `CSV.File` object. The default is to export them as
# `OccurrencesInterface.Occurrences`.

# ::: tip Local files
#
# It is good practice to add the local downloads to `.gitignore` so they are not
# re-distributed alongside the code. If you are working from a GBIF dataset, the
# data can be re-downloaded.
#
# :::

# We will now make a map with the number of observations for *Cardinalis cardinalis*:

#figure map
borders = getpolygon(PolygonData(NaturalEarth, Countries))
bbox = SpeciesDistributionToolkit.boundingbox(records; padding = 2.0)
fig = Figure()
ax = Axis(fig[1, 1]; aspect = DataAspect())
poly!(ax, borders; color = :lightgrey)
xlims!(ax, bbox.left, bbox.right)
ylims!(ax, bbox.bottom, bbox.top)
hexbin!(
    ax,
    presences(records),
    bins = 300,
    colormap = :lipari,
    colorscale = log10,
)
lines!(ax, borders; color = :grey)
current_figure() #hide

# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# GBIF.localarchive
# ```

rm("0069567-260226173443078.zip") #hide