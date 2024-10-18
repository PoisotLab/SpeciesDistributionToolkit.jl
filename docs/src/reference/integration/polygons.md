# Working with polygons

The package assumes that the polygons are read using [the `GeoJSON.jl`
package](https://github.com/JuliaGeo/GeoJSON.jl). As per
[RFC7946](https://datatracker.ietf.org/doc/html/rfc7946), the coordinates in the
polygon must be WGS84.

## Masking

```@docs
SimpleSDMLayers.mask!(layer::SDMLayer, multipolygon::GeoJSON.MultiPolygon)
```

## Trimming

```@docs
trim
```

## Mosaic and zonal-like operations

```@docs
mosaic
zone
byzone
```
