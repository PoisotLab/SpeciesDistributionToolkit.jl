"""
    slidingwindow(L::LT, f::FT, d::IT) where {LT <: SimpleSDMLayer, FT <: Function, IT <: Number}

This function will replace the value at any cell by applying the function `f` to
the array of cells values that are within a distance `d` (in kilometers) from
the focal cell. This is, for example, useful to use an average to smooth out the
layers. The distance is estimated using the haversine distance, assuming that
the radius of the Earth is 6371.0 km. This means that the size of the window
will vary a little bit across latitudes, but this is far better than using a
number of cells, which would have dramatic consequences near the poles.

It *always* returns a `SimpleSDMResponse`, and the cells containing `nothing`
will also not contain a value in the output. This is *different* from the
behavior of `coarsen`, which tends to expand the area of the layer in which we
have data.

This function is currently relatively slow. Performance improvements will arrive
at some point.
"""
function slidingwindow(layer::LT, f::FT, d::IT; threaded::Bool=Threads.nthreads()>1) where {LT <: SimpleSDMLayer, FT <: Function, IT <: Number}
    # We infer the return type from a call to the function on the first three elements
    return_type = typeof(f(collect(layer)[1:min(3, length(layer))]))

    # New layer using typed similar
    N = similar(layer, return_type)

    # Vector of all positions with a value
    filled_positions = keys(layer)

    # We then filter in the occupied positions
    if threaded
        Threads.@threads for pos in filled_positions
            N[pos] = f(_sliding_values(layer, pos, d))
        end
    else
        for pos in filled_positions
           N[pos] = f(_sliding_values(layer, pos, d))
        end
    end

    # And we return the object
    return N
end

function _sliding_values(layer, pt, d; R=6371.0)
    # Bounding box (approx.) for the sliding window of length d at the given point
    max_lat = min(layer.top, pt[2]+(180.0*d)/(π*R))
    min_lat = max(layer.bottom, pt[2]-(180.0*d)/(π*R))
    max_lon = min(layer.right, pt[1]+(360.0*d)/(π*R))
    min_lon = max(layer.left, pt[1]-(360.0*d)/(π*R))

    # Extracted layer for the sliding window
    _tmp = clip(layer; left=min_lon, right=max_lon, top=max_lat, bottom=min_lat)
    
    # Filter the correct positions
    filled_positions = keys(_tmp)
    neighbors = filter(p -> Distances.haversine((pt[1], pt[2]), (p[1], p[2]), R) < d, filled_positions)

    # Return
    return _tmp[neighbors]
end