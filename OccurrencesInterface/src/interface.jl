elements(::T) where {T<:AbstractOccurrenceCollection} = nothing
elements(c::Occurrences) = c.records

entity(o::Occurrence) = o.what
position(o::Occurrence) = o.where
date(o::Occurrence) = o.when
presence(o::Occurrence) = o.presence

for op in [:entity, :position, :date, :presence]
    eval(quote
        $op(::T) where {T<:AbstractOccurrence} = nothing
        $op(c::T) where {T<:AbstractOccurrenceCollection} = [$op(e) for e in elements(c)]
    end)
end

presences(c::T) where {T<:AbstractOccurrenceCollection} = c[findall(presence(c))]
absences(c::T) where {T<:AbstractOccurrenceCollection} = c[findall(!, presence(c))]
