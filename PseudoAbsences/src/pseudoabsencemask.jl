function _layer_works_for_pseudoabsence(layer::SDMLayer{T}) where {T<:Bool}
    iszero(sum(layer)) && throw(ArgumentError("The presences layer is empty"))
    return nothing
end

"""
    pseudoabsencemask(::Type{RandomSelection}, presences::SDMLayer{Bool})

Generates a mask for pseudo-absences using the random selection method. Candidate
cells for the pseudo-absence mask are (i) within the bounding box of the _layer_
(use `SurfaceRangeEnvelope` to use the presences bounding box), and (ii) valued in the
layer.
"""
function pseudoabsencemask(::Type{RandomSelection}, presences::SDMLayer{Bool})
    _layer_works_for_pseudoabsence(presences)
    return !presences
end

@testitem "We can use RandomSelection" begin
    using PseudoAbsences.SimpleSDMLayers
    n = SDMLayer(zeros(Bool, 10, 10))
    n.grid[1] = true
    n.grid[end] = true
    p = pseudoabsencemask(RandomSelection, n)
    @test all(p.grid[2:(end-1)])
end

"""
    pseudoabsencemask(::Type{SurfaceRangeEnvelope}, presences::SDMLayer{Bool})

Generates a mask from which pseudo-absences can be drawn, by picking cells that
are (i) within the bounding box of occurrences, (ii) valued in the layer, and
(iii) not already occupied by an occurrence
"""
function pseudoabsencemask(::Type{SurfaceRangeEnvelope}, presences::SDMLayer{Bool})
    _layer_works_for_pseudoabsence(presences)
    presence_only = nodata(presences, false)
    background = zeros(presences, Bool)
    lon = extrema([k[1] for k in keys(presence_only)])
    lat = extrema([k[2] for k in keys(presence_only)])
    for occupied_cell in keys(presences)
        if lon[1] <= occupied_cell[1] <= lon[2]
            if lat[1] <= occupied_cell[2] <= lat[2]
                if ~(presences[occupied_cell])
                    background[occupied_cell] = true
                end
            end
        end
    end
    return background
end

@testitem "We can use SurfaceRangeEnvelope" begin
    using PseudoAbsences.SimpleSDMLayers
    n = SDMLayer(zeros(Bool, 10, 10))
    n.grid[2, 2] = true
    n.grid[9, 9] = true
    p = pseudoabsencemask(SurfaceRangeEnvelope, n)
    for i in axes(n.grid, 1)
        for j in axes(n.grid, 2)
            if (2 <= i <= 9) & (2 <= j <= 9)
                # Test the surface range
                @test p.grid[i, j] == !n.grid[i, j]
            else
                # Test the exterior borders (all false)
                @test p.grid[i, j] == false
            end
        end
    end
end

"""
    pseudoabsencemask( ::Type{DistanceToEvent}, presences::SDMLayer{Bool}; f = minimum, )

Generates a mask for pseudo-absences using the distance to event method.
Candidate cells are weighted according to their distance to a known observation,
with far away places being more likely. Depending on the distribution of
distances, it may be a very good idea to flatten this layer using `log` or an
exponent. The `f` function is used to determine which distance is reported
(`minimum` by default, but can be any other relevant function).
"""
function pseudoabsencemask(::Type{DistanceToEvent}, presences::SDMLayer{Bool}; f=minimum)
    _layer_works_for_pseudoabsence(presences)
    presence_only = nodata(presences, false)
    background = zeros(presences, Float64)

    prj = SimpleSDMLayers.Proj.Transformation(
        presences.crs,
        "+proj=longlat +datum=WGS84 +no_defs";
        always_xy=true,
    )
    E, N = eastings(presences), northings(presences)

    points = [prj(E[i.I[2]], N[i.I[1]]) for i in keys(presence_only)]

    # Prepare for thread-safe parallelism
    bg = keys(background)
    chunk_size = max(1, length(bg) ÷ (50 * Threads.nthreads()))
    data_chunks = Base.Iterators.partition(bg, chunk_size)
    tasks = map(data_chunks) do chunk
        Threads.@spawn begin
            for k in chunk
                pk = prj(E[k.I[2]], N[k.I[1]])
                background[k] =
                    f([PseudoAbsences._distancefunction(pk, ko) for ko in points])
            end
        end
    end

    # Fetch the tasks
    fetch.(tasks)

    return background
end

function _zero_occ!(bg, presences)
    for i in keys(nodata(presences, false))
        bg[i] = false
    end
    return bg
end

"""
    pseudoabsencemask(::Type{WithinRadius}, presences::SDMLayer{Bool}; distance::Number = 100.0, )

Generates a mask for pseudo-absences where pseudo-absences can be within a
`distance` (in kilometers) of the original observation. Internally, this uses
`DistanceToEvent`. All other keyword arguments are passed to
`pseudoabsencemask`.
"""
function pseudoabsencemask(
    ::Type{WithinRadius},
    presences::SDMLayer{Bool};
    distance::Number=100.0,
    kwargs...
)
    _layer_works_for_pseudoabsence(presences)
    bg = pseudoabsencemask(DistanceToEvent, presences; kwargs...)
    background = bg .<= distance
    return _zero_occ!(background, presences)
end

"""
    pseudoabsencemask(::Type{WithoutRadius}, presences::SDMLayer{Bool}; distance::Number = 100.0, )

Generates a mask for pseudo-absences where pseudo-absences can be outside of a
`distance` (in kilometers) of the original observation. Internally, this uses
`DistanceToEvent`. All other keyword arguments are passed to
`pseudoabsencemask`.
"""
function pseudoabsencemask(
    ::Type{WithoutRadius},
    presences::SDMLayer{Bool};
    distance::Number=100.0,
    kwargs...
)
    _layer_works_for_pseudoabsence(presences)
    bg = pseudoabsencemask(DistanceToEvent, presences; kwargs...)
    background = bg .>= distance
    return _zero_occ!(background, presences)
end


"""
    pseudoabsencemask(::Type{BetweenRadius}, presences::SDMLayer{Bool}; closer::Number = 10.0, further::Number=100.0)

Generates a mask for pseudo-absences where pseudo-absences can be in a band
given by two distances (in kilometers) of the original observation. Internally,
this uses `DistanceToEvent`. All other keyword arguments are passed to
`pseudoabsencemask`.
"""
function pseudoabsencemask(
    ::Type{BetweenRadius},
    presences::SDMLayer{Bool};
    closer::Number=10.0,
    further::Number=100.0,
    kwargs...
)
    _layer_works_for_pseudoabsence(presences)
    bg = pseudoabsencemask(DistanceToEvent, presences; kwargs...)
    background = closer .<= bg .<= further
    return _zero_occ!(background, presences)
end

"""
    pseudoabsencemask( ::Type{DegreesToEvent}, presences::SDMLayer{Bool}; f = minimum, absolute::Bool = false)

Generates a mask for pseudo-absences using the distance to event method.
Candidate cells are weighted according to their distance to a known observation,
with far away places being more likely. The `f` function is used to determine
which distance is reported (`minimum` by default, but can be any other relevant
function). The distance is measured in degrees, and is therefore very sensitive
to the projection / position.

When `absolute` is `false` (the default), the distance is measured as the
absolute difference in coordinates instead of using the Euclidean distance.
"""
function pseudoabsencemask(::Type{DegreesToEvent}, presences::SDMLayer{Bool}; f=minimum, absolute::Bool=false)
    _layer_works_for_pseudoabsence(presences)
    presence_only = nodata(presences, false)
    background = zeros(presences, Float64)

    prj = SimpleSDMLayers.Proj.Transformation(
        presences.crs,
        "+proj=longlat +datum=WGS84 +no_defs";
        always_xy=true,
    )
    E, N = eastings(presences), northings(presences)

    points = [prj(E[i.I[2]], N[i.I[1]]) for i in keys(presence_only)]

    # Distance function used for degrees
    distfunc(pk, ko) = absolute ? sqrt(sum((pk .- ko) .^ 2.0)) : maximum(abs.(pk .- ko))

    # Prepare for thread-safe parallelism
    bg = keys(background)
    chunk_size = max(1, length(bg) ÷ (50 * Threads.nthreads()))
    data_chunks = Base.Iterators.partition(bg, chunk_size)
    tasks = map(data_chunks) do chunk
        Threads.@spawn begin
            for k in chunk
                pk = prj(E[k.I[2]], N[k.I[1]])
                background[k] = f([distfunc(pk, ko) for ko in points])
            end
        end
    end

    # Fetch the tasks
    fetch.(tasks)

    return background
end



"""
    pseudoabsencemask(::Type{WithinDegrees}, presences::SDMLayer{Bool}; distance::Number = 3.0, )

Generates a mask for pseudo-absences where pseudo-absences can be within a
`distance` (in degrees) of the original observation. Internally, this uses
`DegreesToEvent`. All other keyword arguments are passed to `pseudoabsencemask`.
"""
function pseudoabsencemask(
    ::Type{WithinDegrees},
    presences::SDMLayer{Bool};
    distance::Number=3.0,
    kwargs...
)
    _layer_works_for_pseudoabsence(presences)
    bg = pseudoabsencemask(DegreesToEvent, presences; kwargs...)
    background = bg .<= distance
    return _zero_occ!(background, presences)
end

"""
    pseudoabsencemask(::Type{WithoutDegrees}, presences::SDMLayer{Bool}; distance::Number = 3.0, )

Generates a mask for pseudo-absences where pseudo-absences can be outside of a
`distance` (in degrees) of the original observation. Internally, this uses
`DegreesToEvent`. All other keyword arguments are passed to `pseudoabsencemask`.
"""
function pseudoabsencemask(
    ::Type{WithoutDegrees},
    presences::SDMLayer{Bool};
    distance::Number=3.0,
    kwargs...
)
    _layer_works_for_pseudoabsence(presences)
    bg = pseudoabsencemask(DegreesToEvent, presences; kwargs...)
    background = bg .>= distance
    return _zero_occ!(background, presences)
end


"""
    pseudoabsencemask(::Type{BetweenDegrees}, presences::SDMLayer{Bool}; closer::Number = 1.0, further::Number=3.0)

Generates a mask for pseudo-absences where pseudo-absences can be in a band
given by two distances (in degrees) of the original observation. Internally,
this uses `DegreesToEvent`. All other keyword arguments are passed to
`pseudoabsencemask`.
"""
function pseudoabsencemask(
    ::Type{BetweenDegrees},
    presences::SDMLayer{Bool};
    closer::Number=10.0,
    further::Number=100.0,
    kwargs...
)
    _layer_works_for_pseudoabsence(presences)
    bg = pseudoabsencemask(DegreeToEvent, presences; kwargs...)
    background = closer .<= bg .<= further
    return _zero_occ!(background, presences)
end
