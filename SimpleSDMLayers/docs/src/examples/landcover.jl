# # Landcover data

# In this example, we will look at landcover data in Corsica

using SimpleSDMLayers
using Plots

# To avoid loading the (rather large) dataset of land cover at once, we will
# rely on a bounding box:

boundaries = (left=8.25, right=10.0, bottom=41.2, top=43.2)

# The numbers corresponding to the layers can be found in the documentation for
# `SimpleSDMPredictor` - urban area is 9.

urban = SimpleSDMPredictor(EarthEnv, LandCover, 9; boundaries...)

# This dataset is returning data as `UInt8` (as it represents a proportion of
# the pixel occupied by the type), but this is not something that can be plotted
# efficiently (because we rely on `NaN` to indicate no data, and `UInt8` has no
# `NaN`). So in the next step, we will manipulate this object a little bit to
# have something more workable.

urban = convert(Float16, urban)

# Why `Float16`? It is the smallest floating point type with a `NaN` value
# (`NaN16`). We will replace the values of 0 by `nothing`, to only see the
# pixels with *at least* some urban cover:

replace!(urban, zero(eltype(urban)) => nothing)

# With this done, we can plot the results:

plot(urban; c=:berlin, clim=(0, 100))

# Unsuprisingly to anyone who had the chance to visit Corsica, it is not a very
# densely urbanized island. This is a good time to question whether we can look
# at (i) which landcover type dominates within each pixel, and (ii) how
# heterogeneous the land use within each pixel is.

# First, we will download all values for the landcover layers, including open
# water (12).

landcover =
    convert.(
        Float16, SimpleSDMPredictor(EarthEnv, LandCover, 1:12; full=false, boundaries...)
    )

plot(
    plot.(landcover, leg=false, c=:oleron, clim=(0, 100))...;
    leg=false,
    grid=:none,
    frame=:none,
)

# To perform the actual analysis, we will define a `shannon` function, which
# will return the entropy of the land use categories:

function shannon(x)
    v = filter(n -> n > zero(eltype(x)), x)
    length(v) == 0 && return NaN
    v = v ./ sum(v)
    return -sum(v .* log2.(v))
end

entropy = mosaic(shannon, landcover)

# We can also get the index of the most common layer within the pixel:

consensus = mosaic(x -> last(findmax(x)), landcover)

# We may not be *that* interested in fully open water, so let's define a mask to
# remove it:

openwater = broadcast(!isequal(12), consensus)

# All that's left to do is to plot after applying this mask, and we now get a
# map of most common land cover type (left), and land cover heterogeneity
# (right)

p1 = plot(mask(openwater, consensus); c=:terrain, frame=:none)
p2 = plot(mask(openwater, entropy); c=:lapaz, frame=:none)
plot(p1, p2)
