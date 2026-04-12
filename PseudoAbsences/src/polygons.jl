
"""
    pseudoabsencemask(::Type{SurfaceRangeEnvelope}, records::OccurrencesInterface.AbstractOccurrencesCollection)

Generates a mask from which pseudo-absences can be drawn, by picking cells that
are (i) within the bounding box of occurrences, (ii) valued in the layer, and
(iii) not already occupied by an occurrence
"""
function pseudoabsencemask(::Type{SurfaceRangeEnvelope}, records::T) where {T<:OccurrencesInterface.AbstractOccurrenceCollection}
    return nothing
end