function slidingwindow(f::Function, layer::SDMLayer, radius::AbstractFloat; threads::Bool=true)
    return_type = eltype(f(values(layer)[1:min(3, length(layer))]))
    # TODO handle the different type if required
    windowed = similar(layer)
    if threads
        @info "Running on threads"
        Threads.@threads for center in CartesianIndices(layer)
            windowed[center] = f(SDMLayers.__window(layer, center, radius))
        end
    else
        @info "Running on single thread"
        for center in CartesianIndices(layer)
            windowed[center] = f(SDMLayers.__window(layer, center, radius))
        end
    end
    return windowed
end

function __get_bounded_grid_coordinate_by_latlon(layer::SDMLayer, longitude, latitude)
    eastings = LinRange(layer.x..., size(layer.grid, 2) + 1)
    northings = LinRange(layer.y..., size(layer.grid, 1) + 1)
    
    prj = Proj.Transformation("EPSG:4326", layer.crs; always_xy=true)
    easting, northing = prj(longitude, latitude)

    # Prepare the coordinate
    ei = findfirst(easting .<= eastings)-1
    ni = findfirst(northing .<= northings)-1

    ei = iszero(ei) ? 1 : ei
    ni = iszero(ni) ? 1 : ni

    return (ni, ei)
end

function __window(layer::SDMLayer, center::CartesianIndex, radius::AbstractFloat)
    easting_stride = 0.5 * (layer.x[2] - layer.x[1]) / size(layer, 2)
    northing_stride = 0.5 * (layer.y[2] - layer.y[1]) / size(layer, 1)

    eastings = LinRange(layer.x..., size(layer.grid, 2) + 1)[1:(end-1)] .+ easting_stride
    northings = LinRange(layer.y..., size(layer.grid, 1) + 1)[1:(end-1)] .+ northing_stride

    # Center in coordinates
    ce = eastings[center.I[2]]
    cn = northings[center.I[1]]

    # Prepare the projection to EPSG:4326
    prj = Proj.Transformation(layer.crs, "EPSG:4326"; always_xy=true)

    # Get the center of the focal cell
    center_latlon = prj(ce, cn)

    # Approximate lat/lon
    max_lat = center_latlon[2] + (180.0 * 1.001radius) / (π * 6371.0)
    min_lat = center_latlon[2] - (180.0 * 1.001radius) / (π * 6371.0)
    max_lon = center_latlon[1] + (360.0 * 1.001radius) / (π * 6371.0)
    min_lon = center_latlon[1] - (360.0 * 1.001radius) / (π * 6371.0)

    # Convert to grid coordinates
    lower_left = SDMLayers.__get_bounded_grid_coordinate_by_latlon(layer, min_lon, min_lat)
    lower_right = SDMLayers.__get_bounded_grid_coordinate_by_latlon(layer, max_lon, min_lat)
    upper_left = SDMLayers.__get_bounded_grid_coordinate_by_latlon(layer, min_lon, max_lat)
    upper_right = SDMLayers.__get_bounded_grid_coordinate_by_latlon(layer, max_lon, max_lat)

    # Get the range for approximate window
    irange = extrema(first.([lower_left, lower_right, upper_left, upper_right]))
    jrange = extrema(last.([lower_left, lower_right, upper_left, upper_right]))

    valid_indices = CartesianIndices((irange[1]:irange[2], jrange[1]:jrange[2]))

    positions = filter(
        I -> Distances.haversine(center_latlon, prj(eastings[I[2]], northings[I[1]]), 6371.0) < radius,
        valid_indices
    )

    return filter(!isequal(layer.nodata), layer[positions])
end