function sprinkle(layer::SDMLayer)
    content = copy(layer.grid)
    content[.!layer.indices] .= NaN
    return (
        eastings(layer),
        northings(layer),
        transpose(content),
    )
end

function sprinkle(coll::T) where {T <: AbstractOccurrenceCollection}
    lon = Float32.(replace(longitudes(coll), missing => NaN))
    lat = Float32.(replace(latitudes(coll), missing => NaN))
    return (lon, lat)
end

function sprinkle(coll::Vector{T}) where {T <: AbstractOccurrence}
    lon = Float32.(replace(longitudes.(coll), missing => NaN))
    lat = Float32.(replace(latitudes.(coll), missing => NaN))
    return (lon, lat)
end

function MakieCore.convert_arguments(::MakieCore.GridBased, layer::SDMLayer)
    return sprinkle(convert(SDMLayer{Float32}, layer))
end

MakieCore.convert_arguments(P::MakieCore.NoConversion, layer::SDMLayer) =
    MakieCore.convert_arguments(P, values(layer))
MakieCore.convert_arguments(
    P::MakieCore.PointBased,
    occ::T,
) where {T <: AbstractOccurrenceCollection} =
    MakieCore.convert_arguments(P, sprinkle(occ)...)
MakieCore.convert_arguments(
    P::MakieCore.PointBased,
    occ::Vector{T},
) where {T <: AbstractOccurrence} =
    MakieCore.convert_arguments(P, sprinkle(occ)...)

function MakieCore.convert_arguments(
    P::MakieCore.PointBased,
    layer1::T1,
    layer2::T2,
) where {T1 <: SDMLayer, T2 <: SDMLayer}
    k = findall(layer1.indices .& layer2.indices)
    return MakieCore.convert_arguments(P, layer1[k], layer2[k])
end

function MakieCore.convert_arguments(
    P::MakieCore.PointBased,
    layer::T,
) where {T <: SDMLayer{Bool}}
    return MakieCore.convert_arguments(P, sprinkle(ones(nodata(layer, false), Float32))...)
end
