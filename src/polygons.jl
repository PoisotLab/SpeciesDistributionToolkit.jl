function trim(layer::SDMLayer)
    nx = vec(sum(layer.indices, dims=1))
    ny = vec(sum(layer.indices, dims=2))
    rx = findfirst(!iszero, nx):findlast(!iszero, nx)
    ry = findfirst(!iszero, ny):findlast(!iszero, ny)
    nrt = northings(layer)[ry][[1,end]]
    est = eastings(layer)[rx][[1,end]]
    Sy, Sx = stride(layer)
    nrt .+= (-1, 1) .* Sy
    est .+= (-1, 1) .* Sx
    return SDMLayer(grid=layer.grid[ry,rx], indices=layer.indices[ry,rx], x=tuple(est...), y=tuple(nrt...), crs=layer.crs)
end

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

    for position in grid
        if PolygonOps.inpolygon((E[position[2]], N[position[1]]), transformed_polygon) != 0
            inclusion[position] = op
        end
    end
    return inclusion
end

function SimpleSDMLayers.mask!(layer::SDMLayer, multipolygon::GeoJSON.MultiPolygon)
    inclusion = zeros(eltype(layer.indices), size(layer))
    for element in multipolygon
        change_inclusion!(inclusion, layer, element[1], true)
        if length(element) > 2
            for i in 2:length(element)
                change_inclusion!(inclusion, layer, element[i], false)
            end
        end
    end
    layer.indices = inclusion
    return layer
end
