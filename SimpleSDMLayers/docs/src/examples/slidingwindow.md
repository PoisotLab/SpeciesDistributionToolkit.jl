# Sliding window analysis

```@example slide
using SimpleSDMLayers
using Plots
using Statistics

precipitation = worldclim(12; left=-80.0, right=-56.0, bottom=44.0, top=62.0)
```

```@example slide
averaged = slidingwindow(precipitation, Statistics.mean, 100.0)
```

```@example slide
plot(precipitation, c=:alpine)
contour!(averaged, c=:white, lw=2.0)
```
