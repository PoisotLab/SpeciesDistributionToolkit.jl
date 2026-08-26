function __point_in(pt, mpl, ::Type{MultiPolygon})
    for pl in mpl
        if __point_in(pt, pl, Polygon)
            return true
        end
    end
    return false
end

function __point_in(pt, pl, ::Type{Polygon})
    # We check that the point is in the first entry of the geometry
    is_in = isone(PolygonOps.inpolygon(pt, first(pl)))
    if !is_in
        # If the point is not in the polygon, it's fine, we return the answer
        return false
    else
        # If the point is in the polygon, we need to check the potential holes
        if isone(length(pl))
            # If there is only one geometry entry, we can return this directly
            return is_in
        else
            # Otherwise, the polygon has holes, so we need to loop through them
            for i in 2:length(pl)
                if isone(PolygonOps.inpolygon(pt, pl[i]))
                    # If there is a match we know the point is not
                    # in the polygon and we return early
                    return false
                end
            end
            # If the point is not in any holes, we can return the output
            return is_in
        end
    end
end

"""
    trim(layer::SDMLayer)

Returns a layer in which there are no empty rows/columns around the valued
cells. This returns a *new* object. This will only remove the *terminal* empty
rows/columns, so that gaps *inside* the layer are not affected.
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

Return a trimmed version of a layer, according to the feature defined as a
`GeoJSON` object. The object is first masked according to the `feature`, and
then trimmed.
"""
trim(
    layer::SDMLayer,
    feature::T,
) where {T <: Union{Feature, FeatureCollection, Polygon, MultiPolygon}} =
    trim(mask!(copy(layer), feature))

function _reproject(proj, multipoly::MultiPolygon)
    coords = SimpleSDMPolygons.GI.coordinates(multipoly.geometry)
    return MultiPolygon(
        SimpleSDMPolygons.AG.createmultipolygon([[proj.(b) for b in a] for a in coords]),
    )
end

function _reproject(proj, poly::Polygon)
    coords = SimpleSDMPolygons.GI.coordinates(poly.geometry)[1]
    projected_coordinates = [proj(coord) for coord in coords]
    return Polygon(SimpleSDMPolygons.AG.createpolygon(projected_coordinates))
end

function _match_crs(layer, polygon)
    poly_wkt = SimpleSDMPolygons.GI.crs(polygon).val
    layer_wkt = SimpleSDMPolygons.AG.toWKT(projection(layer))

    poly_wkt == layer_wkt && return polygon
    xytrans = SimpleSDMLayers.Proj.Transformation(
        poly_wkt,
        layer_wkt;
        always_xy = true,
    )
    return _reproject(xytrans, polygon)
end

function include!(inclusion, layer, polygon::P) where {P}
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

    # This is threaded again because I'm the G.O.A.T.
    chunk_size = max(1, length(grid) ÷ (10 * Threads.nthreads()))
    data_chunks = Base.Iterators.partition(grid, chunk_size)
    coords = SimpleSDMPolygons.GI.coordinates(transformed_polygon.geometry)

    tasks = map(data_chunks) do chunk
        Threads.@spawn begin
            for position in chunk
                coord = (E[position[2]], N[position[1]])
                val = __point_in(coord, coords, typeof(polygon))
                inclusion[position] = val
            end
        end
    end

    # We get the tasks that are running in parallel
    fetch.(tasks)

    return inclusion
end

"""
    SimpleSDMLayers.mask!(layer::SDMLayer, poly::T) where T<:Union{Polygon,MultiPolygon}

Turns off all the cells outside the polygon (or within holes in the polygon).
This modifies the object.
"""
function SimpleSDMLayers.mask!(
    layer::SDMLayer,
    poly::T,
) where {T <: Union{Polygon, MultiPolygon}}
    inclusion = zeros(eltype(layer.indices), size(layer))
    include!(inclusion, layer, poly)
    layer.indices .&= inclusion
    return layer
end

function SimpleSDMLayers.mask!(
    layers::Vector{<:SDMLayer},
    poly::T,
) where {T <: Union{Polygon, MultiPolygon}}
    inclusion = .!reduce(.|, [l.indices for l in layers])
    include!(inclusion, first(layers), poly)
    for layer in layers
        layer.indices .&= inclusion
    end
    return layers
end

SimpleSDMLayers.mask!(
    layer::L,
    feature::Feature,
) where {L <: Union{<:SDMLayer, Vector{<:SDMLayer}}} =
    mask!(layer, feature.geometry)

function SimpleSDMLayers.mask!(layer::SDMLayer, features::FeatureCollection)
    components = [mask(layer, ft) for ft in features]
    newgrid = reduce(.|, [c.indices for c in components])
    layer.indices .&= newgrid
    return layer
end

function SimpleSDMLayers.mask!(layers::Vector{<:SDMLayer}, features::FeatureCollection)
    mask!(layers[1], features)
    for i in axes(layers, 1)
        layers[i].indices .&= layers[1].indices
    end
    return layers
end

"""
SimpleSDMLayers.mask(layer::L, feature::T) where {L<:Union{<:SDMLayer,Vector{<:SDMLayer}}, T <: Union{Feature, FeatureCollection, Polygon, MultiPolygon}}

Returns a copy of the layer by the polygon.
"""
SimpleSDMLayers.mask(
    layer::L,
    feature::T,
) where {
    L <: Union{<:SDMLayer, Vector{<:SDMLayer}},
    T <: Union{Feature, FeatureCollection, Polygon, MultiPolygon},
} = mask!(copy(layer), feature)

@testitem "We can mask a layer by a FeatureCollection" begin
    const SDT = SpeciesDistributionToolkit

    # Get the region of interest
    polyprovider = PolygonData(OneEarth, Bioregions)
    bioregions = getpolygon(polyprovider)
    northpac = bioregions["Region" => "North America"]["Subregion" => "North Pacific Coast"]

    # Get the temperature
    bbox = (left = -130.1523, right = -115.8625, bottom = 32.2675, top = 57.03458)
    L = SDMLayer(RasterData(CHELSA1, AverageTemperature); bbox...)

    # Mask
    mask(L, northpac)
end

"""
SimpleSDMLayers.mask(occ::T, poly::P) where {T <: AbstractOccurrenceCollection, P<:Union{Polygon,MultiPolygon}}

Returns a copy of the occurrences that are within the polygon.
"""
function SimpleSDMLayers.mask(
    occ::T,
    polygon::P,
) where {T <: AbstractOccurrenceCollection, P <: Union{Polygon, MultiPolygon}}
    inclusion = zeros(Bool, length(elements(occ)))
    coords = SimpleSDMPolygons.GI.coordinates(polygon.geometry)
    places = place(occ)
    for i in eachindex(elements(occ))
        polygon[i] = __point_in(places[i], coords, typeof(polygon))
    end
    return elements(occ)[findall(inclusion)]
end

function SimpleSDMLayers.mask(
    occ::T,
    features::FeatureCollection,
) where {T <: AbstractOccurrenceCollection}
    return vcat([mask(occ, feat) for feat in features.features]...)
end

@testitem "We can mask Occurrences with a FeatureCollection" begin
    polyprovider = PolygonData(OneEarth, Bioregions)
    bioregions = getpolygon(polyprovider)
    northpac = bioregions["Region" => "North America"]["Subregion" => "North Pacific Coast"]
    sightings = OccurrencesInterface.__demodata()
    occ = mask(sightings, northpac)
    @test occ isa Vector{Occurrence}
    @test length(occ) < length(sightings)
end

SimpleSDMLayers.mask(
    occ::T,
    feature::Feature,
) where {T <: AbstractOccurrenceCollection} = mask(occ, feature.geometry)

@testitem "We can mask with a polygon (multi-threaded)" begin
    POL = getpolygon(PolygonData(OpenStreetMap, Places); place = "Switzerland")
    L = SDMLayer(RasterData(CHELSA1, MinimumTemperature), POL)
    Lc = count(L)
    mask!(L, POL)
    @test typeof(L) <: SDMLayer
    @test count(L) <= Lc
end

@testitem "We can deal with polygons with holes correctly" begin
    POL = getpolygon(PolygonData(OpenStreetMap, Places); place = "Montreal")
    bbox = SimpleSDMPolygons.boundingbox(POL)
    layer = SDMLayer(
        ones(Bool, (100, 100));
        x = (Float64(bbox.left), Float64(bbox.right)),
        y = (Float64(bbox.bottom), Float64(bbox.top)),
    )
    # We have masked the polygon
    @test count(layer) < 100*100
    # Points with known inclusions
    @test layer[-73.8, 45.6] === nothing # Outside polygon
    @test layer[-73.6, 45.46] === nothing # Inside polygon and inside hole
    @test layer[-73.6, 45.6] !== nothing # Inside polygon and outside hole
end
