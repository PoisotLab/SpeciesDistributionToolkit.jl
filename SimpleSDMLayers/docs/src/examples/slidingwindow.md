# Sliding window analysis

```@example slide
using SimpleSDMLayers
using Plots
using Statistics

isothermality = worldclim(3; left=-80.0, right=-56.0, bottom=44.0, top=62.0)
```

```@example slide
averaged = slidingwindow(isothermality, Statistics.mean, 100.0)
```

```@example slide
plot(isothermality, c=:alpine)
contour!(averaged, c=:white, lw=2.0)
```
