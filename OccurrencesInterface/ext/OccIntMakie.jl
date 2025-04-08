module OccIntMakie

@info "I spy with my little eye the CairoMakie package"

using MakieCore
using OccurrencesInterface

function _get_lat_lon(coll::T) where {T <: AbstractOccurrenceCollection}
    return _get_lat_lon(elements(coll))
end

function _get_lat_lon(coll::Vector{T}) where {T <: AbstractOccurrence}
    pl = [ismissing(p) ? (NaN, NaN) : p for p in place(coll)]
    return pl
end

MakieCore.convert_arguments( P::MakieCore.PointBased, coll::T, ) where {T <: AbstractOccurrenceCollection} = MakieCore.convert_arguments(P, elements(coll))
MakieCore.convert_arguments( P::MakieCore.PointBased, coll::Vector{T}, ) where {T <: AbstractOccurrence} = MakieCore.convert_arguments(P, _get_lat_lon(coll))

end