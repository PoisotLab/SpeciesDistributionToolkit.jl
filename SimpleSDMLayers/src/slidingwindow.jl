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

"""
    slidingwindow!(destination::SDMLayer, f::Function, layer::SDMLayer; radius::AbstractFloat=100.0)

Performs a sliding window analysis in which all cells in the `destination` layer
receive the output of applying the function `f` to all cells in a radius of
`radius` kilometer on the `layer` layer.

The `f` function _must_ take a vector of value as an input, and _must_ return a
single value as an output. The destination layer _must_ have the correct type
re. what is returned by `f`.

Internally, this function uses threads to speed up calculation quite a bit.
"""
function slidingwindow!(
    destination::SDMLayer,
    f::Function,
    layer::SDMLayer;
    radius::AbstractFloat = 100.0,
)

    # Infer the return type of the operation
    _rtype = eltype(f(values(layer)[1:min(3, length(layer))]))
    if _rtype != eltype(destination)
        throw(
            TypeError(
                :swin!,
                "The destination layer must have the correct type",
                eltype(destination),
                _rtype,
            ),
        )
    end

    est, nor = eastings(layer), northings(layer)

    # Collect keys
    K = keys(layer)

    # Thread-safe structure
    chunk_size = max(1, length(K) ÷ (100 * Threads.nthreads()))
    data_chunks = Base.Iterators.partition(K, chunk_size)

    tasks = map(data_chunks) do chunk
        Threads.@spawn begin
            for k in chunk
                point = (est[k.I[2]], nor[k.I[1]])
                window = _window(nor, est, point, radius)
                vals = [layer.grid[w] for w in window if layer.indices[w]]
                destination.grid[k] = f(vals)
            end
        end
    end

    fetch.(tasks)

    return destination
end

"""
    slidingwindow(f::Function, layer::SDMLayer; kwargs...)

Performs a sliding window analysis in which all cells in the returned layer
receive the output of applying the function `f` to all cells in a radius of
`radius` kilometer on the `layer` layer.

The `f` function _must_ take a vector of value as an input, and _must_ return a
single value as an output. The returned layer will have the type returned by `f`.

Internally, this function uses threads to speed up calculation quite a bit, and
uses the `slidingwindow!` function.
"""
function slidingwindow(f::Function, layer::SDMLayer; kwargs...)
    _rtype = eltype(f(values(layer)[1:min(3, length(layer))]))
    destination = similar(layer, _rtype)
    return slidingwindow!(destination, f, layer; kwargs...)
end

@testitem "We can perform a slidingwindow analysis" begin
    _data_path = joinpath(dirname(dirname(pathof(SimpleSDMLayers))), "data")
    L = SDMLayer(
        joinpath(_data_path, "temperature.tif");
        bandnumber = 1,
        left = 69.0,
        right = 71.0,
        bottom = 38.0,
        top = 40.0,
    )

    C = slidingwindow(x -> sum(x) / length(x), L; radius = 10.0)
    @test C isa typeof(L)
    @test size(C) == size(L)
end

@testitem "We can perform a slidingwindow analysis" begin
    _data_path = joinpath(dirname(dirname(pathof(SimpleSDMLayers))), "data")
    L = SDMLayer(
        joinpath(_data_path, "temperature.tif");
        bandnumber = 1,
        left = 69.0,
        right = 71.0,
        bottom = 38.0,
        top = 40.0,
    )

    C = slidingwindow(x -> one(Float16), L; radius = 10.0)
    @test C isa SDMLayer{Float16}
    @test size(C) == size(L)
    @test all(C.grid .== one(Float16))
    @test !all(L.grid .== 1.0)
end