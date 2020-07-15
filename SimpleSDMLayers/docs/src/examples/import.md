# Importing your own data

In this example, we will see how we can make the packages `SimpleSDMLayers` and
[the `GBIF.jl` package](https://ecojulia.github.io/GBIF.jl/dev/) interact. We
will specifically plot the relationship between temperature and precipitation
for a few occurrences of the kingfisher *Megaceryle alcyon*.

```@example temp
using SimpleSDMLayers
using Plots

#Coin en bas à gauche : -75.17734,45.34523
#Coin en haut à droite : -72.36486,47.38457

file = joinpath(dirname(pathof(SimpleSDMLayers)), "..", "data", "connectivity.tiff")
struct MyConnectivityMap <: SimpleSDMLayers.SimpleSDMSource end
SimpleSDMLayers.latitudes(::Type{MyConnectivityMap}) = (-10.0, 10.0)
SimpleSDMLayers.longitudes(::Type{MyConnectivityMap}) = (-20.0, 20.0)
mp = SimpleSDMLayers.raster(SimpleSDMResponse, MyConnectivityMap(), file)

plot(mp)
```
