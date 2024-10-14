# An interface for occurrence data 

The `OccurrencesInterface` package provides a *lightweight* representation of species
occurrence data. It is meant to be implemented by other packages that want to be
interoperable with the `SpeciesDistributionToolkit` package, which uses this interface for
functions like plotting, masking, and value extraction from occurrence data.

## Types that other packages should use

The interface relies on two abstract types:

```@docs
AbstractOccurrence
AbstractOccurrenceCollection
```

## Concrete types shipping with the package

In order to wrap user-provided data, regardless of its type, the package offers two
concrete types:

```@docs
Occurrence
Occurrences
```

## The interface

In order to implement the interface, packages *must* implement the following methods for
their type that is a subtype of `AbstractOccurrence` or `AbstractOccurrenceCollection`.
None of these methods are optional. Most of these can be implemented as one-liners.

```@docs
elements
entity
place
date
presence
```

## Additional methods

```@docs
presences
absences
```

## The `Tables.jl` interface

The `Occurrences` type is a data source for the `Tables.jl` interface.
