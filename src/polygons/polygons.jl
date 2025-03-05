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
trim(layer::SDMLayer, feature::T) where {T <: GeoJSON.GeoJSONT} =
    trim(mask!(copy(layer), feature))

function change_inclusion!(inclusion, layer, polygon, op)
    xytrans = SimpleSDMLayers.Proj.Transformation(
        "+proj=longlat +datum=WGS84 +no_defs",
        layer.crs;
        always_xy = true,
    )

    transformed_polygon = xytrans.(polygon)
    E, N = eastings(layer), northings(layer)

    lons = extrema(first.(transformed_polygon))
    valid_eastings = findall(e -> lons[1] <= e <= lons[2], eastings(layer))

    lats = extrema(last.(transformed_polygon))
    valid_northings = findall(n -> lats[1] <= n <= lats[2], northings(layer))

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

    tasks = map(data_chunks) do chunk
        Threads.@spawn begin
            for position in chunk
                if PolygonOps.inpolygon(
                    (E[position[2]], N[position[1]]),
                    transformed_polygon,
                ) != 0
                    inclusion[position] = op
                end
            end
        end
    end

    inclusions_batched = fetch.(tasks)
    return inclusion
end

@testitem "We can mask with a polygon (multi-threaded)" begin
    POL = SpeciesDistributionToolkit.openstreetmap("Austria")
    L = SDMLayer(RasterData(CHELSA1, MinimumTemperature); SpeciesDistributionToolkit.boundingbox(POL; padding=1.0)...)
    Lc = count(L)
    mask!(L, POL)
    @test typeof(L) <: SDMLayer
    @test count(L) <= Lc
end

function _get_inclusion_from_polygon!(inclusion, layer, multipolygon::GeoJSON.MultiPolygon)
    for element in multipolygon
        for i in eachindex(element)
            change_inclusion!(inclusion, layer, element[i], true)
        end
    end
end

function SimpleSDMLayers.mask!(
    layers::Vector{<:SDMLayer},
    multipolygon::GeoJSON.MultiPolygon,
)
    inclusion = .!reduce(.|, [l.indices for l in layers])
    _get_inclusion_from_polygon!(inclusion, first(layers), multipolygon)
    for layer in layers
        layer.indices .&= inclusion
    end
    return layers
end

mask(layer::SDMLayer, feature::T) where {T <: GeoJSON.GeoJSONT} =
    mask!(copy(layer), feature)

"""
    SimpleSDMLayers.mask!(layer::SDMLayer, multipolygon::GeoJSON.MultiPolygon)

Turns off all the cells outside the polygon (or within holes in the polygon). This modifies the object.
"""
function SimpleSDMLayers.mask!(layer::SDMLayer, multipolygon::GeoJSON.MultiPolygon)
    inclusion = zeros(eltype(layer.indices), size(layer))
    _get_inclusion_from_polygon!(inclusion, layer, multipolygon)
    layer.indices .&= inclusion
    return layer
end

SimpleSDMLayers.mask!(layer::SDMLayer, features::GeoJSON.FeatureCollection, feature = 1) =
    mask!(layer, features[feature])

SimpleSDMLayers.mask!(
    layers::Vector{<:SDMLayer},
    features::GeoJSON.FeatureCollection,
    feature = 1,
) =
    mask!(layers, features[feature])

SimpleSDMLayers.mask!(layer::SDMLayer, feature::GeoJSON.Feature) =
    mask!(layer, feature.geometry)

SimpleSDMLayers.mask!(layers::Vector{<:SDMLayer}, feature::GeoJSON.Feature) =
    mask!(layers, feature.geometry)

"""
    SimpleSDMLayers.mask(occ::T, multipolygon::GeoJSON.MultiPolygon) where {T <: AsbtractOccurrenceCollection}

Returns a copy of the occurrences that are within the polygon.
"""
function SimpleSDMLayers.mask(
    occ::T,
    multipolygon::GeoJSON.MultiPolygon,
) where {T <: AbstractOccurrenceCollection}
    inclusion = zeros(Bool, length(elements(occ)))
    for element in multipolygon
        for i in eachindex(elements(occ))
            if PolygonOps.inpolygon(
                place(occ)[i],
                element[1],
            ) != 0
                inclusion[i] = true
                if length(element) > 2
                    for i in 2:length(element)
                        if PolygonOps.inpolygon(
                            place(occ)[i],
                            element[i],
                        ) != 0
                            inclusion[i] = false
                        end
                    end
                end
            end
        end
    end
    return elements(occ)[findall(inclusion)]
end

SimpleSDMLayers.mask(
    occ::T,
    features::GeoJSON.FeatureCollection,
    feature = 1,
) where {T <: AbstractOccurrenceCollection} = mask(occ, features[feature])

SimpleSDMLayers.mask(
    occ::T,
    feature::GeoJSON.Feature,
) where {T <: AbstractOccurrenceCollection} = mask(occ, feature.geometry)
