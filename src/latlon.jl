"""
    longitudes(o::AbstractOccurrence)

Returns the longitude for a single occurrence
"""
longitudes(o::T) where {T <: AbstractOccurrence} =
    ismissing(place(o)) ? missing : first(place(o))

"""
    latitudes(o::AbstractOccurrence)

Returns the latitude for a single occurrence
"""
latitudes(o::T) where {T <: AbstractOccurrence} =
    ismissing(place(o)) ? missing : last(place(o))

longitudes(o::T) where {T <: AbstractOccurrenceCollection} = longitudes.(elements(o))
latitudes(o::T) where {T <: AbstractOccurrenceCollection} = latitudes.(elements(o))

longitudes(o::Vector{<:T}) where {T <: AbstractOccurrence} = longitudes.(o)
latitudes(o::Vector{<:T}) where {T <: AbstractOccurrence} = latitudes.(o)