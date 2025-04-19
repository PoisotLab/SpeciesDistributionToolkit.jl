"""
    elements(::T) where {T<:AbstractOccurrenceCollection} 

Returns the elements contained in an abstract collection of occurrences -- this
must be something that can be iterated. The default value, when unimplemented,
is `nothing`. Note that when overloaded as part of your own implementation of
the interface, this must return a `Vector`.
"""
elements(::T) where {T<:AbstractOccurrenceCollection} = nothing
elements(c::Occurrences) = c.records
elements(c::Vector{T}) where {T <: AbstractOccurrence} = c

"""
    entity(o::Occurrence)

Returns the entity (species name) for an occurrence event.
"""
entity(o::Occurrence) = o.what

@testitem "We can get the entity for an occurrence" begin
    occ = Occurrence("sp", true, missing, missing)
    @test entity(occ) == "sp"
end

"""
    place(o::Occurrence)

Returns the place of the occurrence event, either as a tuple of float in the longitude, latitude format, or as `missing`. The CRS is assumed to be WGS84 with no option to change it. This follows the GeoJSON specification.
"""
place(o::Occurrence) = o.where

@testitem "We can get the place when it is not missing" begin
    occ = Occurrence("sp", true, (0.0, 0.0), missing)
    @test !ismissing(place(occ))
    @test place(occ) == (0.0, 0.0)
end

@testitem "We can get the place when it is missing" begin
    occ = Occurrence("sp", true, missing, missing)
    @test ismissing(place(occ))
end

"""
    date(o::Occurrence)

Returns the date (technically a `DateTime` object) documenting the time of occurrence event. Can be `missing` if not known.
"""
date(o::Occurrence) = o.when

"""
    presence(o::Occurrence)

Returns a `Bool` for the occurrence status, where `true` is the presence of the entity and `false` is the (pseudo)absence.
"""
presence(o::Occurrence) = o.presence

for op in [:entity, :place, :date, :presence]
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

        """
            $($op)(::Vector{AbstractOccurrence})

        Default method for any vector of occurrence type for the `$($op)` operation. Unless overloaded, this returns an array of `$($op)` on all `elements` of the argument.
        """
        $op(c::Vector{T}) where {T<:AbstractOccurrence} = [$op(e) for e in elements(c)]
    end)
end

"""
    presences(c::T) where {T<:AbstractOccurrenceCollection}

Returns an `Occurrences` where only the occurrences in the initial collection for which `presence` evaluates to `true` are kept.
"""
presences(c::T) where {T<:AbstractOccurrenceCollection} = Occurrences([e for e in c if presence(e)])

"""
    absences(c::T) where {T<:AbstractOccurrenceCollection}

Returns an `Occurrences` where only the occurrences in the initial collection for which `presence` evaluates to `false` are kept.
"""
absences(c::T) where {T<:AbstractOccurrenceCollection} = Occurrences([e for e in c if !presence(e)])
