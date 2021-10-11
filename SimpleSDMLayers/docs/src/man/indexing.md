# Indexing interface

In versions prior to `0.8`, the indexing syntax (`x[y]`) had been a little bit
abused to mean two different things: getting data out of a raster, and getting a
raster out of a raster. Starting from `0.8`, the indexing interface (*i.e.*
anything relying on `getindex` and `setindex!`) is used to act on values. The
resizing of rasters is now handled by the `clip` function.

## Getting values out of a raster

```@docs
getindex
```

## Writing values in a raster

```@docs
setindex!
```