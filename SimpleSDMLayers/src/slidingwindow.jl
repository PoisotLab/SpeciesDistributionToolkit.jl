_centers(layer::SDMLayer) = _centers(layer, "EPSG:4326")
function _centers(layer::SDMLayer, prj)
    # Projection function
    prfunc = Proj.Transformation(layer.crs, prj; always_xy=true)

    # Northings and eastings for the layer
    nrt, est = northings(layer), eastings(layer)

    # Prepare the centers
    centers = Vector{Tuple{Float64, Float64}}(undef, count(layer))

    # Fill in the information
    for (i,idx) in enumerate(CartesianIndices(layer))
        centers[i] = prfunc(est[idx.I[2]], nrt[idx.I[1]])
    end

    return centers
end

function __get_idx_within_radius(centers, idx, radius)
    # Approximate lat/lon for the valid coordinates
    max_lat = centers[idx][2] + (180.0 * 1.001radius) / (π * 6371.0)
    min_lat = centers[idx][2] - (180.0 * 1.001radius) / (π * 6371.0)
    max_lon = centers[idx][1] + (360.0 * 1.001radius) / (π * 6371.0)
    min_lon = centers[idx][1] - (360.0 * 1.001radius) / (π * 6371.0)

    # Reduce the list of centers
    candidates = findall(c -> (min_lon <= c[1] <= max_lon)&(min_lat <= c[2] <= max_lat), centers)

    # Filter by distance
    window = filter(
        cnd -> Distances.haversine(centers[idx], centers[cnd], 6371.0) <= radius,
        candidates
    )

    # Return
    return window
end


function slidingwindow(f::Function, layer::SDMLayer; kwargs...)
    _rtype = eltype(f(values(layer)[1:min(3, length(layer))]))
    destination = similar(layer, _rtype)
    return slidingwindow!(destination, f, layer; kwargs...)
end

function slidingwindow!(destination::SDMLayer, f::Function, layer::SDMLayer; radius::AbstractFloat=100.0)
    # Infer the return type of the operation
    _rtype = eltype(f(values(layer)[1:min(3, length(layer))]))
    if _rtype != eltype(destination)
        throw(TypeError(:swin!, "The destination layer must have the correct type", eltype(destination), _rtype))
    end

    # Prepare the function to get the lat/lon
    centers = SimpleSDMLayers._centers(layer)

    # Go to town
    for (idx,pos) in enumerate(CartesianIndices(layer))
        window = SimpleSDMLayers.__get_idx_within_radius(centers, idx, radius)
        destination[pos] = f(values(layer)[window])
    end
    return destination
end
