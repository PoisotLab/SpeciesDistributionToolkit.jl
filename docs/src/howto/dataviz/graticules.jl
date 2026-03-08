# # Graticules

# The package has functions to deal with graticules when plotting maps. This is
# only active when a Makie back-end is loaded.

using Revise
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# We will see how to use these functions to plot a map of the mean annual
# temperature in Algeria. We will start by getting polygons with the border
# countries for Africa:

land =
    getpolygon(PolygonData(NaturalEarth, Countries); resolution = 10)["Region" => "Africa"]

pol = land["Algeria"]
bb = SDT.boundingbox(pol)

# With this information, we can get the correct raster:

temp = SDMLayer(RasterData(CHELSA2, BioClim); bb..., layer = "BIO1")
mask!(temp, pol)

# As a reference, this is the default plot we would get with `heatmap`:

heatmap(temp)

# We will work on the projected version of this layer, using an ortho projection
# with the reference longitude and latitude set in the middle of the
# boundingbox.

proj = "+proj=ortho +lon_0=$((bb.right + bb.left)/2) +lat_0=$((bb.top + bb.bottom)/2)"
itemp = interpolate(temp; dest = proj)

# ## The graticule grid

graticulegrid(itemp)
hidedecorations!(current_axis())
hidespines!(current_axis())
current_figure()

# Note that this is *not* an axis. We are using an approach that differs from
# `GeoMakie` and their `GeoAxis`. This is why adding the
# `hidespines!`/`hidedecorations!` is necessary. This being said, the
# `graticulegrid` function has many of the same parameters as a regular axis:

graticulegrid(
    itemp;
    xgridvisible = false,
    ygridcolor = :pink,
    ygridwidth = 6,
    ygridstyle = :dashdot,
)
hidedecorations!(current_axis())
hidespines!(current_axis())
current_figure()

# The `graticulegrid` also has a few additional attributes, like `dms` to
# transform coordinates to degree, miniutes, second, `backgroundcolor` to
# specify a color for the grid, and `alpha` to set the background transparency.
# In addition, the `labels` algorithms is used to specify which spines receive a
# label. It must be given as a symbol with one or more of `l`, `r`, `b`, or
# `t`or as `nothing`.

graticulegrid(itemp; dms = true, backgroundcolor = :skyblue, alpha = 0.2, labels = :br)
hidedecorations!(current_axis())
hidespines!(current_axis())
current_figure()

# As the labels on the side are text, Makie will not adjust the axis limits in
# order to make it fit. We can use the `enlargelimits!` function, which expands
# the limits by a scaling factor in either direction.

enlargelimits!(current_axis(); x = 0.1, y = 0.2)
current_figure()

# If there are too many or too few ticks, you can use the `minticks`, `ticks`,
# and `maxticks` (prefaced by `x` or `y`) to tweak the behavior of the tick
# algorithm:

graticulegrid(
    itemp;
    dms = true,
    backgroundcolor = :skyblue,
    alpha = 0.2,
    xminticks = 2,
    xmaxticks = 4,
)
hidedecorations!(current_axis())
hidespines!(current_axis())
enlargelimits!(current_axis(); x = 0.15)
current_figure()

# Note that here, we are building the graticule grid by giving the layer
# directly. In practice, we can build graticule grids by giving a bounding box
# and a projection:

graticule = (SDT.boundingbox(pol; padding = 3.0), projection(itemp))

# We can now simply splat this into the call to graticule drawing functions:

graticulegrid(graticule...; dms = true)
hidedecorations!(current_axis())
hidespines!(current_axis())
enlargelimits!(current_axis(); x = 0.15)
current_figure()

# This is a much more useful way to deal with the limits of plotting.

# ## The graticule box

# The second step of the process is to add a box around the graticule grid:

graticulebox!(graticule...)
current_figure()

# The `graticule` box function takes most of the arguments used in `Axis` to
# draw spines:

graticulebox(
    graticule...;
    leftspinecolor = :pink,
    bottomspinevisible = false,
    spinewidth = 2,
    topspinecolor = :lime,
)
hidedecorations!(current_axis())
hidespines!(current_axis())
current_figure()

# ## An illustration

# We will now use these functions to draw a map of Algeria, which will show the
# boundaries of neighboring countries, the mean annual temperature, and the
# projected coordinates.

# We start by clipping and reprojecting the polygons for countries border:

clip_land = reproject(clip(land, first(graticule)), proj)

# We will start by setting up a figure with a graticule grid:

f = Figure(; size = (650, 500))
ax = Axis(f[1, 1]; aspect = DataAspect())
graticulegrid!(
    ax,
    graticule...;
    labels = :lb,
    backgroundcolor = :skyblue,
    xgridstyle = :dash,
    ygridstyle = :dash,
    xgridcolor = :grey60,
    ygridcolor = :grey60,
    alpha = 0.1,
    dms = true,
)
hidespines!(ax)
hidedecorations!(ax)
current_figure()

# We enlarge the limits a little to fit the labels:

enlargelimits!(ax; x = 0.2, y = 0.15)
current_figure()

# Now that this is done, we can color in the landmass:

poly!(ax, clip_land; color = :grey95)
lines!(ax, clip_land; color = :grey40, linewidth = 0.8)
current_figure()

# Now we add the raster we want to plot, and highlight its border:

hm = heatmap!(ax, itemp; colormap = :thermal)
lines!(ax, reproject(pol, proj); color = :grey10, linewidth = 0.8)
current_figure()

# We add the graticulebox:

graticulebox!(ax, graticule...; spinewidth = 1.5)
current_figure()

# And we finish with the rest of the figure elements:

ax.title = "BIO1 variable for Algeria"
ax.subtitle = "Sources: NaturalEarth / CHELSA v2.1"
ax.titlealign = :left
Colorbar(
    f[1, 2],
    hm;
    height = Relative(0.7),
    label = "Temperature (°C)",
    vertical = true,
)
current_figure()