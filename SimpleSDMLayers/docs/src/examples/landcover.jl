# # Getting landcover data

# In this example, we will look at landcover data, specifically the proportion
# of urban/built area in Europe; the entire dataset is very large to fit in
# memory, as it has a resolution of about 1 kilometre squared. Therefore, we
# will take advantage of the ability to only load the part that matters by
# passing the limits of a bounding box.

using SimpleSDMLayers
using Plots

urban = SimpleSDMPredictor(EarthEnv, LandCover, 9; left=-11.0, right=31.1, bottom=29.0, top=71.1)

# This dataset is returning data as `UInt8` (as it represents a proportion of
# the pixel occupied by the type), but this is not something that can be plotted
# efficiently. So in the next step, we will manipulate this object a little bit
# to have something more workable.

urban = convert(Float32, urban)

# We will replace the values of 0 by `nothing`, to only see the pixels with some
# urban cover:

replace!(urban, zero(eltype(urban)) => nothing)

# With this done, we can plot the results:

heatmap(urban, c=:berlin)
