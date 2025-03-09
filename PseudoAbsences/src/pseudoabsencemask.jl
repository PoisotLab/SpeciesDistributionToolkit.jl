function _layer_works_for_pseudoabsence(layer::SDMLayer{T}) where {T <: Bool}
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

"""
    pseudoabsencemask( ::Type{DistanceToEvent}, presences::SDMLayer{Bool}; f = minimum, )

Generates a mask for pseudo-absences using the distance to event method.
Candidate cells are weighted according to their distance to a known observation,
with far away places being more likely. Depending on the distribution of
distances, it may be a very good idea to flatten this layer using `log` or an
exponent. The `f` function is used to determine which distance is reported
(`minimum` by default, but can be any other relevant function).
"""
function pseudoabsencemask(::Type{DistanceToEvent}, presences::SDMLayer{Bool}; f = minimum)
    _layer_works_for_pseudoabsence(presences)
    presence_only = nodata(presences, false)
    background = zeros(presences, Float64)

    prj = SimpleSDMLayers.Proj.Transformation(
        presences.crs,
        "+proj=longlat +datum=WGS84 +no_defs";
        always_xy = true,
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

"""
    pseudoabsencemask(::Type{WithinRadius}, presences::SDMLayer{Bool}; distance::Number = 100.0, )

Generates a mask for pseudo-absences where pseudo-absences can be within a
`distance` (in kilometers) of the original observation. Internally, this uses
`DistanceToEvent`.
"""
function pseudoabsencemask(
    ::Type{WithinRadius},
    presences::SDMLayer{Bool};
    distance::Number = 100.0,
)
    _layer_works_for_pseudoabsence(presences)
    bg = pseudoabsencemask(DistanceToEvent, presences; f = minimum)
    background = bg .<= distance
    for i in keys(nodata(presences, false))
        background[i] = false
    end
    return background
end
