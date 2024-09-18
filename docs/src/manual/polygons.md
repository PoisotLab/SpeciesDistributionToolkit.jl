# Working with polygons

The package assumes that the polygons are read using [the `GeoJSON.jl`
package](https://github.com/JuliaGeo/GeoJSON.jl). As per
[RFC7946](https://datatracker.ietf.org/doc/html/rfc7946), the coordinates in the
polygon are assumed to be WGS84.

## Masking

 ```@docs
 SimpleSDMLayers.mask!(layer::SDMLayer, multipolygon::GeoJSON.MultiPolygon)
 SimpleSDMLayers.mask(records::GBIFRecords, multipolygon::GeoJSON.MultiPolygon)
 ```

## Trimming

```@docs
trim
```

## Mosaic and zonal-like operations

```@docs
SimpleSDMLayers.mosaic(f, layer::SDMLayer, polygons::T, args...; kwargs...) where {T <: GeoJSON.GeoJSONT}
zone
byzone
```