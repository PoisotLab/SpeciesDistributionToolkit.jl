## Preparation

# Load required packages
using SimpleSDMLayers
using GBIF
using Statistics
using Plots

# Get world temperature data
temperature_world = worldclim(1)

## Common manipulations

# Clip to Europe
temperature_europe = temperature_world[left=-11.2, right=30.6, bottom=29.2, top=71.0];
# Coarsen resolution
temperature_coarse = coarsen(temperature_europe, Statistics.mean, (4, 4))
# Sliding window averaging
temperature_slided = slidingwindow(temperature_europe, Statistics.mean, 100.0)

## Easily plot
p1 = plot(temperature_europe)
p2 = plot(temperature_coarse)
p3 = plot(temperature_slided)
p = plot(p1, p2, p3, layout = grid(1, 3, widths = [0.29, 0.29, 0.405]), 
         frame = :box, ticks = false, colorbar = [false false true])

## GBIF integration

# Get Belted Kingfisher occurrences from GBIF
kingfisher = GBIF.taxon("Megaceryle alcyon", strict=true)
kf_occurrences = occurrences(kingfisher)
# Get at least 200 occurrences
while length(kf_occurrences) < 200
    occurrences!(kf_occurrences)
    @info "$(length(kf_occurrences)) occurrences"
end

# Clip layer to occurrences
temperature_clip = clip(temperature_world, kf_occurrences)

# Plot occurrences
contour(temperature_clip, fill=true, colorbar_title = "Average temperature (°C)",
                  xguide = "Longitude", yguide = "Latitude")
scatter!(longitudes(kf_occurrences), latitudes(kf_occurrences), 
         label = "Kingfisher occurrences", legend = :bottomleft, 
         c = :white, msc = :orange)

precipitation_clip = clip(worldclim(12), kf_occurrences)
histogram2d(temperature_clip, precipitation_clip, c = :viridis)
scatter!(temperature_clip[kf_occurrences], precipitation_clip[kf_occurrences], 
         label = :none, xlabel = "Temperature (°C)", ylabel = "Precipitation (mm)",
         colorbar_title = "Number of sites",
         c = :white, msc = :orange)