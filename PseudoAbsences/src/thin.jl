function adjacency(records, threshold)

    n = length(records)
    A = sparse([], [], Bool[], n, n)

    for i in axes(A, 1)
        for j in axes(A, 2)
            if j > i
                d = PseudoAbsences._distancefunction(place(records[i]), place(records[j]))
                if d < threshold
                    A[i, j] = true
                    A[j, i] = true
                end
            end
        end
    end

    return A
end

"""
    _window_size_in_degrees(d, records)

From a distance in km, returns the size of the window in degrees within which
occurrences will be thinned. A buffer of 5% is applied to the box.
"""
function _window_size_in_degrees(d, records)
    lats = last.(OccurrencesInterface.place(records))
    medlat = (maximum(lats) - minimum(lats))/ 2
    @info medlat
    km_per_deg = cos(medlat * π / 180) * 111325.0 / 1000.0
    return 1.05 * (d / km_per_deg)
end

"""
    thin(records::T, d::Float64) where {T <: AbstractOccurrenceCollection}

Returns a spatially thinned collection of occurrences so that no points are
closer than `d` kilometers from one another. This function works by picking
points that have the largest number of neighbors (points within a distance `d`),
and pruning all their neighbors at the same time, until the desired thinning is
achieved. This approach ensures that the list of thinned points can be produced
as rapidly as possible.
"""
function thin(
    records::T,
    d::Float64
) where {T<:OccurrencesInterface.AbstractOccurrenceCollection}

    n = length(records)
    D = sparse([], [], Bool[], n, n)

    # Radius for the search
    r = PseudoAbsences._window_size_in_degrees(d, records)

    # This is useful to keep track of the potential starting points for a
    # thinning operation
    keep = BitVector(zeros(Bool, n))
    visited = BitVector(zeros(Bool, n))
    removed = BitVector(zeros(Bool, n))

    eligible = findall(.!visited .& .!removed)

    focal = StatsBase.sample(eligible)

    # Records to look at here
    candidates = findall(
        e ->
            (abs(place(e)[1] - place(records[focal])[1]) <= r) &
            (abs(place(e)[2] - place(records[focal])[2]) <= r), elements(records)
    )

    # We get their distances
    D = [
        PseudoAbsences._distancefunction(place(records[focal]), place(records[i]))
        for i in candidates
        ]

    # Then we updated
    visited[focal] = true
    for i in eachindex(D)
        if candidates[i] != focal
            if D[i] <= D
                removed[i] = true
            end
        end
    end

    # We start by getting the records with adjacent records (they must be
    # pruned)
    n_violations = vec(sum(D, dims=1))
    keep[findall(iszero, n_violations)] .= true

    while sum(D) != 0

        n_violations = vec(sum(D, dims=1))

        # Next we pick a random record with many possible adjacent records
        candidate = StatsBase.sample(StatsBase.Weights(n_violations))

        # We keep this point!
        keep[candidate] = true

        # We identify the neighbors of this record
        neighbors = findall(D[:, candidate])

        # We do not keep these neighbors
        keep[neighbors] .= false
        D[neighbors, :] .= false
        D[:, neighbors] .= false

        # We update the sparsity structure of the matrix
        dropzeros!(D)
    end

    return records[findall(keep)]
end

@testitem "We can spatially thin the reduced demo dataset" begin
    using PseudoAbsences.OccurrencesInterface
    records = OccurrencesInterface.__demodata()
    records = Occurrences(filter(
        e ->
            (-130. <= place(e)[1] <= -110.) &
            (30. <= place(e)[2] <= 50.), elements(records)
    ))

    thinned = thin(records, 150.)
    @test length(thinned) < length(records)
end

@testitem "We get the correct distance when thinning" begin
    using PseudoAbsences.OccurrencesInterface
    records = OccurrencesInterface.__demodata()
    records = Occurrences(filter(
        e ->
            (-130. <= place(e)[1] <= -110.) &
            (30. <= place(e)[2] <= 50.), elements(records)
    ))

    thinned = thin(records, 25.)

    @test sum(PseudoAbsences.adjacency(thinned, 24.9)) == 0
    @test sum(PseudoAbsences.adjacency(thinned, 150.0)) > 0
end

@testitem "We do not lose clusters of overlapping points when thinning" begin
    using PseudoAbsences.OccurrencesInterface
    cluster1 = [Occurrence(where=(0.0, 0.0)) for _ in Base.OneTo(10)]
    cluster2 = [Occurrence(where=(90., 90.)) for _ in Base.OneTo(10)]
    records = Occurrences([cluster1; cluster2])

    thinned = thin(records, 25.)
    @test length(thinned) == 2
end