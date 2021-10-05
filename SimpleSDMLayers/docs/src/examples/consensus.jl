# # Landcover consensus

# In this example, we will create a consensus map of landcover for Corsica based
# on the EarthEnv data, and measure the variation within each pixel using the
# variance. The first step is to load the packages we need, and create a
# bounding box:

using SimpleSDMLayers
using Plots

#-

bbox = (left=8.25, right=10.0, bottom=41.2, top=43.2)

# First, we will download all values for our layers:

lc = convert.(Float32, SimpleSDMPredictor(EarthEnv, LandCover, 1:12; full=false, bbox...))

# To perform the actual analysis, we will define a `shannon` function, which
# will return the entropy of the land use categories:

function shannon(x)
    v = filter(n -> n>zero(eltype(x)), x)
    length(v) == 0 && return NaN
    v = v ./ sum(v)
    return -sum(v.*log2.(v))
end

# We can then apply these functions using the `mosaic` method:

consensus = mosaic(x -> last(findmax(x)), lc)

#-

entropy = mosaic(shannon, lc)

#-

p1 = plot(consensus, c=:terrain, frame=:none)
p2 = plot(entropy, c=:bamako, frame=:none)
plot(p1, p2)

