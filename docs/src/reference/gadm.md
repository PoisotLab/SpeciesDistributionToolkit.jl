# Access GADM polygons

The package come with a *very* lightweight series of convenience functions to
interact with [GADM](https://gadm.org/). The [`GADM.jl`
package](https://github.com/JuliaGeo/GADM.jl) is an alternative solution to the
same problem.

All methods assume that the first argument is an alpha-3 code valid under [ISO
3166-1](https://www.iso.org/obp/ui/#search), and the following levels are
sub-divisions of this territory.

## Accessing polygons

```@docs
SpeciesDistributionToolkit.gadm
```

## Listing polygons

```@docs
SpeciesDistributionToolkit.gadmlist
```
