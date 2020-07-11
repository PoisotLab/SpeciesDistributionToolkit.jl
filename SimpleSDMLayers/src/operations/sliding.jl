function haversine(p1, p2; R=6371.0)
    lon1, lat1 = p1
    lon2, lat2 = p2
    φ1 = lat1 * π/180.0
    φ2 = lat2 * π/180.0
    Δφ = (lat2-lat1) * π/180.0
    Δλ = (lon2-lon1) * π/180.0
    a = sin(Δφ/2.0)^2.0 + cos(φ1)*cos(φ2) * sin(Δλ)^2.0
    c = 2.0 * atan(sqrt(a), sqrt(1.0-a))
    return R*c
end

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
function slidingwindow(L::LT, f::FT, d::IT) where {LT <: SimpleSDMLayer, FT <: Function, IT <: Number}
    newgrid = Array{Any}(nothing, size(L))
    N = SimpleSDMResponse(newgrid, L)
    pixels = []
    for lat in latitudes(L)
        for lon in longitudes(L)
            if !isnothing(L[lon,lat])
                push!(pixels, (lon, lat) => L[lon,lat])
            end
        end
    end

    for p1 in pixels
        ok = filter(p2 -> haversine(p2.first, p1.first) < 100.0, pixels)
        val = [p2.second for p2 in ok]
        N[p1.first...] = f(val)
    end

    internal_types = unique(typeof.(N.grid))
    N.grid = convert(Matrix{Union{internal_types...}}, N.grid)

    return N
end
