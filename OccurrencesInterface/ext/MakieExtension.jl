module MakieExtension

import Makie
using OccurrencesInterface

function _get_lat_lon(coll::T) where {T <: AbstractOccurrenceCollection}
    return _get_lat_lon(elements(coll))
end

function _get_lat_lon(coll::Vector{T}) where {T <: AbstractOccurrence}
    pl = [ismissing(p) ? (NaN, NaN) : p for p in place(coll)]
    return pl
end

Makie.convert_arguments( P::Makie.PointBased, coll::T, ) where {T <: AbstractOccurrenceCollection} = Makie.convert_arguments(P, elements(coll))
Makie.convert_arguments( P::Makie.PointBased, coll::Vector{T}, ) where {T <: AbstractOccurrence} = Makie.convert_arguments(P, _get_lat_lon(coll))

end