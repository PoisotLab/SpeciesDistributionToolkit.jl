var documenterSearchIndex = {"docs":
[{"location":"#An-interface-for-occurrence-data","page":"An interface for occurrence data","title":"An interface for occurrence data","text":"","category":"section"},{"location":"","page":"An interface for occurrence data","title":"An interface for occurrence data","text":"The OccurrencesInterface package provides a lightweight representation of species occurrence data. It is meant to be implemented by other packages that want to be interoperable with the SpeciesDistributionToolkit package, which uses this interface for functions like plotting, masking, and value extraction from occurrence data.","category":"page"},{"location":"#Types-that-other-packages-should-use","page":"An interface for occurrence data","title":"Types that other packages should use","text":"","category":"section"},{"location":"","page":"An interface for occurrence data","title":"An interface for occurrence data","text":"The interface relies on two abstract types:","category":"page"},{"location":"","page":"An interface for occurrence data","title":"An interface for occurrence data","text":"AbstractOccurrence\nAbstractOccurrenceCollection","category":"page"},{"location":"#OccurrencesInterface.AbstractOccurrence","page":"An interface for occurrence data","title":"OccurrencesInterface.AbstractOccurrence","text":"AbstractOccurrence\n\nOther types describing a single observation should be sub-types of this. Occurrences are always defined as a single observation of a single species.\n\n\n\n\n\n","category":"type"},{"location":"#OccurrencesInterface.AbstractOccurrenceCollection","page":"An interface for occurrence data","title":"OccurrencesInterface.AbstractOccurrenceCollection","text":"AbstractOccurrenceCollection\n\nOther types describing multiple observations can be sub-types of this. Occurrences collections are a way to collect multiple observations of arbitrarily many species.\n\n\n\n\n\n","category":"type"},{"location":"#Concrete-types-shipping-with-the-package","page":"An interface for occurrence data","title":"Concrete types shipping with the package","text":"","category":"section"},{"location":"","page":"An interface for occurrence data","title":"An interface for occurrence data","text":"In order to wrap user-provided data, regardless of its type, the package offers two concrete types:","category":"page"},{"location":"","page":"An interface for occurrence data","title":"An interface for occurrence data","text":"Occurrence\nOccurrences","category":"page"},{"location":"#OccurrencesInterface.Occurrence","page":"An interface for occurrence data","title":"OccurrencesInterface.Occurrence","text":"Occurrence\n\nThis is a sub-type of AbstractOccurrence, with the following types:\n\nwhat - species name, defaults to \"\"\npresence - a boolean to mark the presence of the species, defaults to true\nwhere - a tuple giving the location as longitude,latitude in WGS84, or missing, defaults to missing\nwhen - a DateTime giving the date of observation, or missing, defaults to missing\n\nWhen the interface is properly implemented for any type that is a sub-type of AbstractOccurrence, there is an Occurrence object can be created directly with e.g. Occurrence(observation). There is, similarly, an automatically implemented convert method.\n\n\n\n\n\n","category":"type"},{"location":"#OccurrencesInterface.Occurrences","page":"An interface for occurrence data","title":"OccurrencesInterface.Occurrences","text":"Occurrences\n\nThis is a sub-type of AbstractOccurrenceCollection. No default value.\n\n\n\n\n\n","category":"type"},{"location":"#The-interface","page":"An interface for occurrence data","title":"The interface","text":"","category":"section"},{"location":"","page":"An interface for occurrence data","title":"An interface for occurrence data","text":"In order to implement the interface, packages must implement the following methods for their type that is a subtype of AbstractOccurrence or AbstractOccurrenceCollection. None of these methods are optional. Most of these can be implemented as one-liners.","category":"page"},{"location":"","page":"An interface for occurrence data","title":"An interface for occurrence data","text":"elements\nentity\nplace\ndate\npresence","category":"page"},{"location":"#OccurrencesInterface.elements","page":"An interface for occurrence data","title":"OccurrencesInterface.elements","text":"elements(::T) where {T<:AbstractOccurrenceCollection}\n\nReturns the elements contained in an abstract collection of occurrences – this must be something that can be iterated. The default value, when unimplemented, is nothing.\n\n\n\n\n\n","category":"function"},{"location":"#OccurrencesInterface.entity","page":"An interface for occurrence data","title":"OccurrencesInterface.entity","text":"entity(o::Occurrence)\n\nReturns the entity (species name) for an occurrence event.\n\n\n\n\n\nentity(::AbstractOccurrence)\n\nDefault method for any abstract occurrence type for the entity operation. Unless overloaded, this returns nothing.\n\n\n\n\n\nentity(::AbstractOccurrenceCollection)\n\nDefault method for any abstract occurrence collection type for the entity operation. Unless overloaded, this returns an array of entity on all elements of the argument.\n\n\n\n\n\n","category":"function"},{"location":"#OccurrencesInterface.place","page":"An interface for occurrence data","title":"OccurrencesInterface.place","text":"place(o::Occurrence)\n\nReturns the place of the occurrence event, either as a tuple of float in the longitude, latitude format, or as missing. The CRS is assumed to be WGS84 with no option to change it. This follows the GeoJSON specification.\n\n\n\n\n\nplace(::AbstractOccurrence)\n\nDefault method for any abstract occurrence type for the place operation. Unless overloaded, this returns nothing.\n\n\n\n\n\nplace(::AbstractOccurrenceCollection)\n\nDefault method for any abstract occurrence collection type for the place operation. Unless overloaded, this returns an array of place on all elements of the argument.\n\n\n\n\n\n","category":"function"},{"location":"#OccurrencesInterface.date","page":"An interface for occurrence data","title":"OccurrencesInterface.date","text":"date(o::Occurrence)\n\nReturns the date (technically a DateTime object) documenting the time of occurrence event. Can be missing if not known.\n\n\n\n\n\ndate(::AbstractOccurrence)\n\nDefault method for any abstract occurrence type for the date operation. Unless overloaded, this returns nothing.\n\n\n\n\n\ndate(::AbstractOccurrenceCollection)\n\nDefault method for any abstract occurrence collection type for the date operation. Unless overloaded, this returns an array of date on all elements of the argument.\n\n\n\n\n\n","category":"function"},{"location":"#OccurrencesInterface.presence","page":"An interface for occurrence data","title":"OccurrencesInterface.presence","text":"presence(o::Occurrence)\n\nReturns a Bool for the occurrence status, where true is the presence of the entity and false is the (pseudo)absence.\n\n\n\n\n\npresence(::AbstractOccurrence)\n\nDefault method for any abstract occurrence type for the presence operation. Unless overloaded, this returns nothing.\n\n\n\n\n\npresence(::AbstractOccurrenceCollection)\n\nDefault method for any abstract occurrence collection type for the presence operation. Unless overloaded, this returns an array of presence on all elements of the argument.\n\n\n\n\n\n","category":"function"},{"location":"#Additional-methods","page":"An interface for occurrence data","title":"Additional methods","text":"","category":"section"},{"location":"","page":"An interface for occurrence data","title":"An interface for occurrence data","text":"presences\nabsences","category":"page"},{"location":"#OccurrencesInterface.presences","page":"An interface for occurrence data","title":"OccurrencesInterface.presences","text":"presences(c::T) where {T<:AbstractOccurrenceCollection}\n\nReturns an Occurrences where only the occurrences in the initial collection for which presence evaluates to true are kept.\n\n\n\n\n\n","category":"function"},{"location":"#OccurrencesInterface.absences","page":"An interface for occurrence data","title":"OccurrencesInterface.absences","text":"absences(c::T) where {T<:AbstractOccurrenceCollection}\n\nReturns an Occurrences where only the occurrences in the initial collection for which presence evaluates to false are kept.\n\n\n\n\n\n","category":"function"},{"location":"#The-Tables.jl-interface","page":"An interface for occurrence data","title":"The Tables.jl interface","text":"","category":"section"},{"location":"","page":"An interface for occurrence data","title":"An interface for occurrence data","text":"The Occurrences type is a data source for the Tables.jl interface.","category":"page"}]
}
