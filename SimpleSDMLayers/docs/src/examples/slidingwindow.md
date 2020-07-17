# Sliding window analysis

In this example, we will get precipitation data from Québec, and use a sliding
window analysis to smooth them out. The beginning of the code should now be
familiar:

```@example slide
using SimpleSDMLayers
using Plots
using Statistics

precipitation = worldclim(12; left=-80.0, right=-56.0, bottom=44.0, top=62.0)
```

The sliding window works by taking all pixels *within a given radius* (expressed
in kilometres) around the pixel of interest, and then applying the function
given as the second argument to their values. Empty pixels are removed. In this
case, we will do a summary across a 100 km radius around each pixel:

```@example slide
averaged = slidingwindow(precipitation, Statistics.mean, 100.0)
```

We can finally overlap the two layers -- the result of sliding window is a
little bit smoother than the raw data.

```@example slide
plot(precipitation, c=:alpine)
contour!(averaged, c=:white, lw=2.0)
```
