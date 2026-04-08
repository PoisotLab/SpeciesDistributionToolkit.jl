"""
    boundingbox()

Returns a tuple with coordinates left, right, bottom, top in WGS84, which can be
used to decide which part of a raster should be loaded.
"""
boundingbox() = nothing

_padbbox(l, r, b, t, p) = (left = l - p, right = r + p, bottom = b - p, top = t + p)
_padbbox(l, r, b, t; padding = 0.0) = _padbbox(l, r, b, t, padding)

"""
    boundingbox(occ::AbstractOccurrenceCollection; padding=0.0)

Returns the bounding box for a collection of occurrences, with an additional
padding.
"""
function boundingbox(occ::AbstractOccurrenceCollection; padding = 0.0)
    left, right = extrema(skipmissing(longitudes(occ)))
    bottom, top = extrema(skipmissing(latitudes(occ)))
    return _padbbox(left, right, bottom, top, padding)
end

@testitem "We can get the boundingbox for occurrences with missing places" begin
    occ = [Occurrence("", true, (1.0i, 1.0i), missing) for i in 1:5]
    push!(occ, Occurrence("", true, missing, missing))
    bbox = SpeciesDistributionToolkit.boundingbox(occ)
    @test bbox.left == 1.0
    @test bbox.bottom == 1.0
    @test bbox.right == 5.0
    @test bbox.top == 5.0
end

"""
    boundingbox(occ::Vector{<:AbstractOccurrence}; padding=0.0)

Returns the bounding box for a vector of abstract occurrences, with an
additional padding.
"""
function boundingbox(occ::Vector{<:AbstractOccurrence}; padding = 0.0)
    left, right = extrema(skipmissing(longitudes(occ)))
    bottom, top = extrema(skipmissing(latitudes(occ)))
    return _padbbox(left, right, bottom, top, padding)
end

"""
    boundingbox(layer::SDMLayer; padding=0.0)

Returns the bounding box for a layer, with an additional padding.
"""
function boundingbox(layer::SDMLayer; padding = 0.0)
    EL = eastings(layer)
    NL = northings(layer)
    prj = SimpleSDMLayers.Proj.Transformation(
        SimpleSDMLayers.AG.toPROJ4(projection(layer)),
        "+proj=longlat +datum=WGS84 +no_defs";
        always_xy = true,
    )

    b1 = [prj(EL[1], n) for n in NL]
    b2 = [prj(EL[end], n) for n in NL]
    b3 = [prj(e, NL[1]) for e in EL]
    b4 = [prj(e, NL[end]) for e in EL]
    bands = vcat(b1, b2, b3, b4)

    left, right = extrema(first.(bands))
    bottom, top = extrema(last.(bands))

    return _padbbox(left, right, bottom, top, padding)
end

function _reconcile(boxes)
    return (
        left = minimum([b.left for b in boxes]),
        right = maximum([b.right for b in boxes]),
        bottom = minimum([b.bottom for b in boxes]),
        top = maximum([b.top for b in boxes]),
    )
end

# GeoJSON

function boundingbox(fc::GeoJSON.FeatureCollection; kwargs...)
    return _reconcile([boundingbox(ft; kwargs...) for ft in fc.geometry])
end

function boundingbox(fc::GeoJSON.Feature; kwargs...)
    return _reconcile([boundingbox(ft; kwargs...) for ft in fc.geometry])
end

function boundingbox(fc::GeoJSON.MultiPolygon{2, F}; kwargs...) where {F <: AbstractFloat}
    return _reconcile([boundingbox(vcat(ft...); kwargs...) for ft in fc])
end

# Vector of points

function boundingbox(fc::Vector{Tuple{F, F}}; kwargs...) where {F <: AbstractFloat}
    lons = [c[1] for c in fc]
    lats = [c[2] for c in fc]
    return _padbbox(extrema(lons)..., extrema(lats)...; kwargs...)
end

# SimpleSDMPolygons

const _SDMPOLY_TYPES = Union{
    SimpleSDMPolygons.FeatureCollection,
    SimpleSDMPolygons.Feature,
    SimpleSDMPolygons.Polygon,
    SimpleSDMPolygons.MultiPolygon,
}

function boundingbox(fc::T; kwargs...) where {T <: _SDMPOLY_TYPES}
    return SimpleSDMPolygons.boundingbox(fc.geometry; kwargs...)
end

function boundingbox(fc::SimpleSDMPolygons.FeatureCollection; kwargs...)
    return _reconcile([SimpleSDMPolygons.boundingbox(ft; kwargs...) for ft in fc.features])
end

@testitem "We can apply boundingbox to each type of Polygon" begin
    fc = getpolygon(PolygonData(OpenStreetMap, Places); place = "Lausanne")
    feat = fc[1]
    mp = feat.geometry
    pol = SpeciesDistributionToolkit.SimpleSDMPolygons.Polygon(
        SpeciesDistributionToolkit.SimpleSDMPolygons.AG.getgeom(mp.geometry, 1),
    )

    @test SimpleSDMPolygons.boundingbox(fc) isa NamedTuple
    @test SimpleSDMPolygons.boundingbox(feat) isa NamedTuple
    @test SimpleSDMPolygons.boundingbox(mp) isa NamedTuple
    @test SimpleSDMPolygons.boundingbox(pol) isa NamedTuple
end

# Models
"""
    boundingbox(sdm::AbstractSDM; padding=0.0)

Returns the bounding box for a georeferenced model, with an additional padding.
"""
function boundingbox(sdm::AbstractSDM; padding = 0.0)
    if isgeoreferenced(sdm)
        left, right = extrema(first.(sdm.coordinates))
        bottom, top = extrema(last.(sdm.coordinates))
        return _padbbox(left, right, bottom, top, padding)
    else
        return nothing
    end
end

@testitem "We can get the boundingbox for a model" begin
    sdm = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    bb = SpeciesDistributionToolkit.boundingbox(sdm)
    @test bb.left < 8.6 
    @test bb.right > 9.5
    @test bb.bottom < 41.4
    @test bb.top > 42.9
end

@testitem "We cannot get a boundingbox for a non-georeferenced model" begin
    X, y, C = SDeMo.__demodata()
    sdm = SDM(RawData, NaiveBayes, X, y)
    @test !isgeoreferenced(sdm)
    bb = SpeciesDistributionToolkit.boundingbox(sdm)
    @test isnothing(bb)
end