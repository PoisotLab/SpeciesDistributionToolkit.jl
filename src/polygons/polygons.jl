"""
    trim(layer::SDMLayer)

Returns a layer in which there are no empty rows/columns around the valued cells.
This returns a *new* object. This will only remove the *terminal* empty rows/columns, so that gaps *inside* the layer are not affected.
"""
function trim(layer::SDMLayer)
    nx = vec(sum(layer.indices; dims = 1))
    ny = vec(sum(layer.indices; dims = 2))
    rx = findfirst(!iszero, nx):findlast(!iszero, nx)
    ry = findfirst(!iszero, ny):findlast(!iszero, ny)
    nrt = northings(layer)[ry][[1, end]]
    est = eastings(layer)[rx][[1, end]]
    Sy, Sx = stride(layer)
    nrt .+= (-1, 1) .* Sy
    est .+= (-1, 1) .* Sx
    return SDMLayer(;
        grid = layer.grid[ry, rx],
        indices = layer.indices[ry, rx],
        x = tuple(est...),
        y = tuple(nrt...),
        crs = layer.crs,
    )
end

"""
    trim(layer::SDMLayer, feature::T) where {T <: GeoJSON.GeoJSONT}

Return a trimmed version of a layer, according to the feature defined a
`GeoJSON` object. The object is first masked according to the `feature`, and then trimmed.
"""
trim(layer::SDMLayer, feature::T) where {T <: Union{Feature, FeatureCollection, Polygon, MultiPolygon}} =
    trim(mask!(copy(layer), feature))


function _reproject(proj, multipoly::MultiPolygon)
    coords = SimpleSDMPolygons.GI.coordinates(multipoly.geometry)
    MultiPolygon(SimpleSDMPolygons.AG.createmultipolygon([[proj.(b) for b in a] for a in coords]))
end

function _reproject(proj, poly::Polygon)
    coords = SimpleSDMPolygons.GI.coordinates(poly.geometry)[1]
    Polygon(SimpleSDMPolygons.AG.createpolygon([proj.(a) for a in coords]))
end


function _match_crs(layer, polygon)
    poly_wkt = SimpleSDMPolygons.GI.crs(polygon).val
    layer_wkt = SimpleSDMPolygons.AG.toWKT(SimpleSDMPolygons.AG.importPROJ4(layer.crs))

    poly_wkt == layer_wkt && return polygon 
    xytrans = SimpleSDMLayers.Proj.Transformation(
        poly_wkt,
        layer_wkt,
        always_xy = true,
    )
    return _reproject(xytrans, polygon)
end

function change_inclusion!(inclusion, layer, polygon::P) where P
    transformed_polygon = _match_crs(layer, polygon)
    E, N = eastings(layer), northings(layer)

    bbox = SimpleSDMPolygons.boundingbox(transformed_polygon)
    valid_eastings = findall(e -> bbox.left <= e <= bbox.right, eastings(layer))
    valid_northings = findall(n -> bbox.bottom <= n <= bbox.top, northings(layer))

    if isempty(valid_northings)
        return nothing
    end
    if isempty(valid_eastings)
        return nothing
    end

    grid = CartesianIndices((
        valid_northings[1]:valid_northings[end],
        valid_eastings[1]:valid_eastings[end],
    ))

    # Thread-safe structure
    chunk_size = max(1, length(grid) ÷ (10 * Threads.nthreads()))
    data_chunks = Base.Iterators.partition(grid, chunk_size)

    coords = SimpleSDMPolygons.GI.coordinates(transformed_polygon.geometry)

    tasks = map(data_chunks) do chunk
        Threads.@spawn begin
            for position in chunk
                coord = (E[position[2]], N[position[1]])
                val = false 
                if polygon isa MultiPolygon
                    val = any(isone, vcat([[PolygonOps.inpolygon(coord, ci) for ci in c] for c in coords]...))
                else
                    val = any(isone, [PolygonOps.inpolygon(coord, c) for c in coords]...)
                end 
                inclusion[position] = val
            end
        end
    end

    inclusions_batched = fetch.(tasks)
    return inclusion
end

_get_inclusion_from_polygon!(inclusion, layer, poly::T) where T<:Union{Polygon,MultiPolygon} = 
    change_inclusion!(inclusion, layer, poly)

"""
    SimpleSDMLayers.mask!(layer::SDMLayer, poly::T) where T<:Union{Polygon,MultiPolygon}

Turns off all the cells outside the polygon (or within holes in the polygon). This modifies the object.
"""
function SimpleSDMLayers.mask!(layer::SDMLayer, poly::T) where T<:Union{Polygon,MultiPolygon}
    inclusion = zeros(eltype(layer.indices), size(layer))
    _get_inclusion_from_polygon!(inclusion, layer, poly)
    layer.indices .&= inclusion
    return layer
end

function SimpleSDMLayers.mask!(
    layers::Vector{<:SDMLayer},
    poly::T,
) where T<:Union{Polygon,MultiPolygon}
    inclusion = .!reduce(.|, [l.indices for l in layers])
    _get_inclusion_from_polygon!(inclusion, first(layers), poly)
    for layer in layers
        layer.indices .&= inclusion
    end
    return layers
end


SimpleSDMLayers.mask!(layer::L, feature::Feature)  where {L<:Union{<:SDMLayer,Vector{<:SDMLayer}}} =
    mask!(layer, feature.geometry)

function SimpleSDMLayers.mask!(layer::L, features::FeatureCollection) where{L<:Union{<:SDMLayer,Vector{<:SDMLayer}}}
    for feat in features
        mask!(layer, feat)
    end 
end 

"""
   SimpleSDMLayers.mask(layer::L, feature::T) where {L<:Union{<:SDMLayer,Vector{<:SDMLayer}}, T <: Union{Feature, FeatureCollection, Polygon, MultiPolygon}}

Returns a copy of the layer by the polygon.
"""
SimpleSDMLayers.mask(layer::L, feature::T) where {
    L <: Union{<:SDMLayer,Vector{<:SDMLayer}},
    T <: Union{Feature, FeatureCollection, Polygon, MultiPolygon}
    } = mask!(copy(layer), feature)

"""
    SimpleSDMLayers.mask(occ::T, poly::P) where {T <: AbstractOccurrenceCollection, P<:Union{Polygon,MultiPolygon}}

Returns a copy of the occurrences that are within the polygon.
"""
function SimpleSDMLayers.mask(
    occ::T,
    poly::P
) where {T <: AbstractOccurrenceCollection, P<:Union{Polygon,MultiPolygon}}
    inclusion = zeros(Bool, length(elements(occ)))
    for i in eachindex(elements(occ))
        inclusion[i] = PolygonOps.inpolygon(place(occ)[i], poly) 
    end
    return elements(occ)[findall(inclusion)]
end

function SimpleSDMLayers.mask(
    occ::T,
    features::FeatureCollection
) where {T <: AbstractOccurrenceCollection} 
    for feat in features 
        occ = mask(occ, feat)
    end 
end 

SimpleSDMLayers.mask(
    occ::T,
    feature::Feature
) where {T <: AbstractOccurrenceCollection} = mask(occ, feature.geometry)


@testitem "We can mask with a polygon (multi-threaded)" begin
    POL = getpolygon(PolygonData(OpenStreetMap, Places), place="Switzerland")
    L = SDMLayer(RasterData(CHELSA1, MinimumTemperature); SpeciesDistributionToolkit.boundingbox(POL; padding=1.0)...)
    Lc = count(L)
    mask!(L, POL)
    @test typeof(L) <: SDMLayer
    @test count(L) <= Lc
end