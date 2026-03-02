using SimpleSDMLayers
import BenchmarkTools as BT
using CairoMakie

# Data
_data_path = joinpath(dirname(dirname(pathof(SimpleSDMLayers))), "data")
L = SDMLayer(joinpath(_data_path, "temperature.tif"); bandnumber = 1)

_dx_from_point(point, distance) = 1.0 / (111.319 * cos(point[2] * (π / 180.0))) * distance
_dy_from_point(point, distance) = 1.0 / 110.574 * distance

function _window(nor, est, point, r)
    CIs = CartesianIndex[]
    dy = _dy_from_point(point, r)
    y_min = max(Base.Sort.searchsortedfirst(nor, point[2] - dy), 1)
    y_max = min(Base.Sort.searchsortedfirst(nor, point[2] + dy), length(nor))
    H = SimpleSDMLayers.Distances.Haversine(6371.0)
    for y in y_min:y_max
        d = H(point, (point[1], nor[y]))
        if d <= r
            chord = 2 * sqrt(r^2 - min(r, d)^2)
            dx = _dx_from_point((point[1], nor[y]), chord / 2)
            x_min = max(Base.Sort.searchsortedfirst(est, point[1] - dx), 1)
            x_max = min(Base.Sort.searchsortedfirst(est, point[1] + dx), length(est))
            append!(CIs, [CartesianIndex(y, x) for x in x_min:x_max])
        end
    end
    return CIs
end

function slodonwodo!(C, f, L, r)
    est, nor = eastings(L), northings(L)

    # Collect keys
    K = keys(L)

    # Thread-safe structure
    chunk_size = max(1, length(K) ÷ (100 * Threads.nthreads()))
    data_chunks = Base.Iterators.partition(K, chunk_size)

    tasks = map(data_chunks) do chunk
        Threads.@spawn begin
            for k in chunk
                point = (est[k.I[2]], nor[k.I[1]])
                window = _window(nor, est, point, r)
                vals = [L.grid[w] for w in window if L.indices[w]]
                C.grid[k] = f(vals)
            end
        end
    end

    fetch.(tasks)

    return C
end

C = copy(L)
@profview slodonwodo!(C, x -> sum(x) / length(x), L, 15.0)

BT.@btime slodonwodo!(C, x -> sum(x) / length(x), L, 15.0)

slodonwodo!(C, x -> sum(x) / length(x), L, 10.0)
heatmap(C - L; axis = (; aspect = DataAspect()))