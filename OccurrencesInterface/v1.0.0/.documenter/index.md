
# An interface for occurrence data {#An-interface-for-occurrence-data}

The `OccurrencesInterface` package provides a _lightweight_ representation of species occurrence data. It is meant to be implemented by other packages that want to be interoperable with the `SpeciesDistributionToolkit` package, which uses this interface for functions like plotting, masking, and value extraction from occurrence data.

## Types that other packages should use {#Types-that-other-packages-should-use}

The interface relies on two abstract types:
<details class='jldocstring custom-block' open>
<summary><a id='OccurrencesInterface.AbstractOccurrence' href='#OccurrencesInterface.AbstractOccurrence'><span class="jlbinding">OccurrencesInterface.AbstractOccurrence</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
AbstractOccurrence
```


Other types describing a single observation should be sub-types of this. Occurrences are always defined as a single observation of a single species.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/6cb246120d9c532dcc72942b6dc3d97ca7395560/OccurrencesInterface/src/types.jl#L1-L5)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='OccurrencesInterface.AbstractOccurrenceCollection' href='#OccurrencesInterface.AbstractOccurrenceCollection'><span class="jlbinding">OccurrencesInterface.AbstractOccurrenceCollection</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
AbstractOccurrenceCollection
```


Other types describing multiple observations can be sub-types of this. Occurrences collections are a way to collect multiple observations of arbitrarily many species.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/6cb246120d9c532dcc72942b6dc3d97ca7395560/OccurrencesInterface/src/types.jl#L8-L12)

</details>


## Concrete types shipping with the package {#Concrete-types-shipping-with-the-package}

In order to wrap user-provided data, regardless of its type, the package offers two concrete types:
<details class='jldocstring custom-block' open>
<summary><a id='OccurrencesInterface.Occurrence' href='#OccurrencesInterface.Occurrence'><span class="jlbinding">OccurrencesInterface.Occurrence</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
Occurrence
```


This is a sub-type of `AbstractOccurrence`, with the following types:
- `what` - species name, defaults to `""`
  
- `presence` - a boolean to mark the presence of the species, defaults to `true`
  
- `where` - a tuple giving the location as longitude,latitude in WGS84, or `missing`, defaults to `missing`
  
- `when` - a `DateTime` giving the date of observation, or `missing`, defaults to `missing`
  

When the interface is properly implemented for any type that is a sub-type of `AbstractOccurrence`, there is an `Occurrence` object can be created directly with _e.g._ `Occurrence(observation)`. There is, similarly, an automatically implemented `convert` method.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/6cb246120d9c532dcc72942b6dc3d97ca7395560/OccurrencesInterface/src/types.jl#L15-L26)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='OccurrencesInterface.Occurrences' href='#OccurrencesInterface.Occurrences'><span class="jlbinding">OccurrencesInterface.Occurrences</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
Occurrences
```


This is a sub-type of `AbstractOccurrenceCollection`. No default value.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/6cb246120d9c532dcc72942b6dc3d97ca7395560/OccurrencesInterface/src/types.jl#L40-L44)

</details>


## The interface {#The-interface}

In order to implement the interface, packages _must_ implement the following methods for their type that is a subtype of `AbstractOccurrence` or `AbstractOccurrenceCollection`. None of these methods are optional. Most of these can be implemented as one-liners.
<details class='jldocstring custom-block' open>
<summary><a id='OccurrencesInterface.elements' href='#OccurrencesInterface.elements'><span class="jlbinding">OccurrencesInterface.elements</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
elements(::T) where {T<:AbstractOccurrenceCollection}
```


Returns the elements contained in an abstract collection of occurrences – this must be something that can be iterated. The default value, when unimplemented, is `nothing`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/6cb246120d9c532dcc72942b6dc3d97ca7395560/OccurrencesInterface/src/interface.jl#L1-L5)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='OccurrencesInterface.entity' href='#OccurrencesInterface.entity'><span class="jlbinding">OccurrencesInterface.entity</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
entity(o::Occurrence)
```


Returns the entity (species name) for an occurrence event.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/6cb246120d9c532dcc72942b6dc3d97ca7395560/OccurrencesInterface/src/interface.jl#L9-L13)



```julia
entity(::AbstractOccurrence)
```


Default method for any abstract occurrence type for the `entity` operation. Unless overloaded, this returns `nothing`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/6cb246120d9c532dcc72942b6dc3d97ca7395560/OccurrencesInterface/src/interface.jl#L55-L59)



```julia
entity(::AbstractOccurrenceCollection)
```


Default method for any abstract occurrence collection type for the `entity` operation. Unless overloaded, this returns an array of `entity` on all `elements` of the argument.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/6cb246120d9c532dcc72942b6dc3d97ca7395560/OccurrencesInterface/src/interface.jl#L62-L66)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='OccurrencesInterface.place' href='#OccurrencesInterface.place'><span class="jlbinding">OccurrencesInterface.place</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
place(o::Occurrence)
```


Returns the place of the occurrence event, either as a tuple of float in the longitude, latitude format, or as `missing`. The CRS is assumed to be WGS84 with no option to change it. This follows the GeoJSON specification.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/6cb246120d9c532dcc72942b6dc3d97ca7395560/OccurrencesInterface/src/interface.jl#L21-L25)



```julia
place(::AbstractOccurrence)
```


Default method for any abstract occurrence type for the `place` operation. Unless overloaded, this returns `nothing`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/6cb246120d9c532dcc72942b6dc3d97ca7395560/OccurrencesInterface/src/interface.jl#L55-L59)



```julia
place(::AbstractOccurrenceCollection)
```


Default method for any abstract occurrence collection type for the `place` operation. Unless overloaded, this returns an array of `place` on all `elements` of the argument.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/6cb246120d9c532dcc72942b6dc3d97ca7395560/OccurrencesInterface/src/interface.jl#L62-L66)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='OccurrencesInterface.date' href='#OccurrencesInterface.date'><span class="jlbinding">OccurrencesInterface.date</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
date(o::Occurrence)
```


Returns the date (technically a `DateTime` object) documenting the time of occurrence event. Can be `missing` if not known.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/6cb246120d9c532dcc72942b6dc3d97ca7395560/OccurrencesInterface/src/interface.jl#L39-L43)



```julia
date(::AbstractOccurrence)
```


Default method for any abstract occurrence type for the `date` operation. Unless overloaded, this returns `nothing`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/6cb246120d9c532dcc72942b6dc3d97ca7395560/OccurrencesInterface/src/interface.jl#L55-L59)



```julia
date(::AbstractOccurrenceCollection)
```


Default method for any abstract occurrence collection type for the `date` operation. Unless overloaded, this returns an array of `date` on all `elements` of the argument.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/6cb246120d9c532dcc72942b6dc3d97ca7395560/OccurrencesInterface/src/interface.jl#L62-L66)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='OccurrencesInterface.presence' href='#OccurrencesInterface.presence'><span class="jlbinding">OccurrencesInterface.presence</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
presence(o::Occurrence)
```


Returns a `Bool` for the occurrence status, where `true` is the presence of the entity and `false` is the (pseudo)absence.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/6cb246120d9c532dcc72942b6dc3d97ca7395560/OccurrencesInterface/src/interface.jl#L46-L50)



```julia
presence(::AbstractOccurrence)
```


Default method for any abstract occurrence type for the `presence` operation. Unless overloaded, this returns `nothing`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/6cb246120d9c532dcc72942b6dc3d97ca7395560/OccurrencesInterface/src/interface.jl#L55-L59)



```julia
presence(::AbstractOccurrenceCollection)
```


Default method for any abstract occurrence collection type for the `presence` operation. Unless overloaded, this returns an array of `presence` on all `elements` of the argument.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/6cb246120d9c532dcc72942b6dc3d97ca7395560/OccurrencesInterface/src/interface.jl#L62-L66)

</details>


## Additional methods {#Additional-methods}
<details class='jldocstring custom-block' open>
<summary><a id='OccurrencesInterface.presences' href='#OccurrencesInterface.presences'><span class="jlbinding">OccurrencesInterface.presences</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
presences(c::T) where {T<:AbstractOccurrenceCollection}
```


Returns an `Occurrences` where only the occurrences in the initial collection for which `presence` evaluates to `true` are kept.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/6cb246120d9c532dcc72942b6dc3d97ca7395560/OccurrencesInterface/src/interface.jl#L71-L75)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='OccurrencesInterface.absences' href='#OccurrencesInterface.absences'><span class="jlbinding">OccurrencesInterface.absences</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
absences(c::T) where {T<:AbstractOccurrenceCollection}
```


Returns an `Occurrences` where only the occurrences in the initial collection for which `presence` evaluates to `false` are kept.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/6cb246120d9c532dcc72942b6dc3d97ca7395560/OccurrencesInterface/src/interface.jl#L78-L82)

</details>


## The `Tables.jl` interface {#The-Tables.jl-interface}

The `Occurrences` type is a data source for the `Tables.jl` interface.
