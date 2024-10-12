# An interface for occurrence data 

## Types that other packages should use

```@docs
AbstractOccurrence
AbstractOccurrenceCollection
```

## Concrete types shipping with the package

```@docs
Occurrence
Occurrences
```

## The interface

```@docs
elements
entity
place
date
presence
presences
absences
```

## The `Tables.jl` interface

The `Occurrences` type is a data source for the `Tables.jl` interface.
