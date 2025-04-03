# SimpleSDMPolygons 

A unified interface for working with Polygon data in [`SpeciesDistributionToolkit.jl`](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl).

## Usage

### EPA Ecoregions

```julia
pd = PolygonData(EPA, Ecoregions)
ecoregion_path = downloader(pd; level=1)

pd = PolygonData(EPA, Ecoregions)
ecoregion_path = downloader(pd; level=2)

pd = PolygonData(EPA, Ecoregions)
ecoregion_path = downloader(pd; level=3)
```

### NaturalEarth

```julia
pd = PolygonData(NaturalEarth, Land)
fc = downloader(pd; resolution=10)

pd = PolygonData(NaturalEarth, Countries)
fc = downloader(pd; resolution=50)

pd = PolygonData(NaturalEarth, ParksAndProtected)
fc = downloader(pd; resolution=10)

pd = PolygonData(NaturalEarth, Lakes)
fc = downloader(pd; resolution=50)

pd = PolygonData(NaturalEarth, Oceans)
fc = downloader(pd; resolution=50)

```

### UCDavis' GADM 

Note: specification of subgeometries based on list of strings e.g. `("CAN", "Québec", "Drummond")` is not yet supported but should be simple enough to implement

```julia
pd = PolygonData(UCDavis, Countries)
fc = downloader(pd; country = "CAN", level=0)

pd = PolygonData(UCDavis, Countries)
fc = downloader(pd; country = "CAN", level=1)

pd = PolygonData(UCDavis, Countries)
fc = downloader(pd; country = "CAN", level=2)

pd = PolygonData(UCDavis, Countries)
fc = downloader(pd; country = "CAN", level=3)
```

### OpenStreetMap
```julia
pd = PolygonData(OpenStreetMap, Countries)
fc = downloader(pd; country="Colombia")
```
