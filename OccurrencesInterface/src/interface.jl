elements(::T) where {T<:AbstractOccurrenceCollection} = nothing
elements(c::Occurrences) = c.records

"""
    entity(o::Occurrence)

Returns the entity (species name) for an occurrence event.
"""
entity(o::Occurrence) = o.what

"""
    position(o::Occurrence) = o.where

Returns the position of the occurrence event, either as a tuple of float in the longitude, latitude format, or as `missing`.
"""
position(o::Occurrence) = o.where
date(o::Occurrence) = o.when
presence(o::Occurrence) = o.presence

for op in [:entity, :position, :date, :presence]
    eval(quote
        """
            $($op)(::AbstractOccurrence)

        Default method for any abstract occurrence type for the `$($op)` operation. Unless overloaded, this returns `nothing`.
        """
        $op(::T) where {T<:AbstractOccurrence} = nothing

        """
            $($op)(::AbstractOccurrenceCollection)

        Default method for any abstract occurrence collection type for the `$($op)` operation. Unless overloaded, this returns an array of `$($op)` on all `elements` of the argument.
        """
        $op(c::T) where {T<:AbstractOccurrenceCollection} = [$op(e) for e in elements(c)]
    end)
end

presences(c::T) where {T<:AbstractOccurrenceCollection} = Occurrences(c[findall(presence(c))])
absences(c::T) where {T<:AbstractOccurrenceCollection} = Occurrences(c[findall(!, presence(c))])
