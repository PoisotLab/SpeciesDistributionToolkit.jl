# Pseudo absences generation

## Supported algorithms

```@docs
SpeciesDistributionToolkit.PseudoAbsenceGenerator
WithinRadius
SurfaceRangeEnvelope
RandomSelection
```

## Generation of a pseudo-absence mask

The above algorithms are used in conjunction with `pseudoabsencemask` to
generate a Boolean layer that contains all pixels in which a background point
can be. They do *not* generate background points directly, in order to allow
more flexible workflows based on clipping Boolean masks, for example.

```@docs
pseudoabsencemask
```

## Sampling of background points

```@docs
backgroundpoints
```
