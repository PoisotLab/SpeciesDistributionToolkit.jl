function _maxlat(L, ref, d)
    inc = minimum(stride(L))
    nr = inc
    while SimpleSDMLayers.haversine(ref, (ref[1], ref[2]+nr)) < 1.5d
        nr += inc
    end
    return nr
end

function _maxlon(L, ref, d)
    inc = minimum(stride(L))
    nr = inc
    while SimpleSDMLayers.haversine(ref, (ref[1]+nr, ref[2])) < 1.5d
        nr += inc
    end
    return nr
end

function fastslide(L::LT, f::FT, d::IT) where {LT <: SimpleSDMLayer, FT <: Function, IT <: Number}
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
    
    # Get the sizes

    for p1 in pixels
        _lon, _lat = _maxlon(L, p1.first, d), _maxlat(L, p1.first, d)
        @info _lon, _lat
        p2 = filter(x -> p1.first[1]-_lon <= x.first[1] <= p1.first[1]+_lon, pixels)
        filter!(x -> p1.first[2]-_lat <= x.first[2] <= p1.first[2]+_lat, p2)
        ok = filter(x -> SimpleSDMLayers.haversine(x.first, x.first) < d, p2)
        N[p1.first...] = f([p2.second for p2 in ok])
    end

    internal_types = unique(typeof.(N.grid))
    N.grid = convert(Matrix{Union{internal_types...}}, N.grid)
    N = typeof(L) <: SimpleSDMPredictor ? convert(SimpleSDMPredictor, N) : N

    return N
end




@time averaged = slidingwindow(precipitation, Statistics.mean, 100.0)
@time averaged = fastslide(precipitation, Statistics.mean, 100.0)