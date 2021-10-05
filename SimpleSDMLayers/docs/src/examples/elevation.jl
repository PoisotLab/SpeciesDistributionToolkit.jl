# # Basics: elevation data

# In this example, we will look at elevation data from the worldclim 2 data,
# crop it for Western Europe, and then change the resolution to aggregate the
# data. The first step is to get the worldclim layer for elevation:

using SimpleSDMLayers
using StatsPlots
import Statistics

#-

elevation = convert(Float32, SimpleSDMPredictor(WorldClim, Elevation))

# Thanks to the integration with Plots and StatsPlots, we can very rapidly
# visualize these data:

heatmap(elevation, c=:cividis, frame=:box)
xaxis!("Longitude")
yaxis!("Latitude")

# Let's also have a look at the density while we're at it:

density(elevation, frame=:zerolines, c=:grey, fill=(0, :grey, 0.2), leg=false)
xaxis!("Elevation")

# The next step is to clip the data to the region of interest. This requires a
# the coordinates of the bounding box as two tuples (for longitude and latitude)
# -- we can also make a quick heatmap to see what the region looks like:

elevation_europe = clip(elevation; left=-11.0, right=31.5, bottom=29.0, top=71.5)

#-

heatmap(elevation_europe, c=:cividis, aspectratio=1, frame=:box)

# The next step will be to coarsen these data, which requires to give the number
# of cells to merge alongside each dimension. This number of cells must be a
# divider of the grid size, which we can view with:

size(elevation_europe)

# In an ideal world, we could want to find a number of cells that is the same both
# for latitude and longitude, and one approach is to finagle our way into a
# correct grid by changing the clipping region.

# In this case, we will use a coarsening scale of `(5,5)`, which gives us a total
# of 25 cells in the aggregated result. Our aggregation function will be `mean`
# (so we report the average elevation across these cells):

elevation_europe_coarse = coarsen(elevation_europe, Statistics.mean, (5, 5))

# Once again, we can plot these data:

heatmap(elevation_europe_coarse, aspectratio=1, c=:cividis, frame=:box)

# Finally, we can compare our different clipping and approximations to the overall
# dataset:

density(elevation, frame=:zerolines, c=:grey, fill=(0, :grey, 0.5), lab="")
density!(elevation_europe, c=:black, lab="Raw data")
density!(elevation_europe_coarse, c=:darkgrey, lab="Average")
xaxis!("Elevation")

