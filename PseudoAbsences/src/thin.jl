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
occurrences will be thinned.
"""
function _window_size_in_degrees(d, records)
    lats = last.(places(records))
    medlat = (maximum(lats) - minimum(lats))/ 2
    km_per_deg = cos(medlat * π / 180) * 111325.0
    return d / km_per_deg    
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

    D = PseudoAbsences.adjacency(records, d)

    keep = BitVector(zeros(Bool, length(records)))

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