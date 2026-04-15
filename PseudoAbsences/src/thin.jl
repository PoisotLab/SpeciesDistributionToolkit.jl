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
occurrences will be thinned. This is returned as the size for longitudes and the
size for latitudes. The distance in degrees is increased by 2%.
"""
function _window_size_in_degrees(d, records)
    lats = last.(OccurrencesInterface.place(records))
    medlat = (maximum(lats) - minimum(lats))/ 2
    km_per_deg = cos(medlat * π / 180) * 111325.0 / 1000.0
    return 1.05 * (d / km_per_deg)
end

"""
    thin(records::T, d::Float64) where {T <: AbstractOccurrenceCollection}

Returns a spatially thinned collection of occurrences so that no points are
closer than `d` kilometers from one another. This function works with an on-line
approach, by picking points at random, then identifying a square bounding box of
the correct size, and finally removing all points within this box that are too
close to the focal point. This is repeated until all points have been removed or
visited. Because points are removed as soon as possible (and are never visited
again), this method will usually converge before having evaluated `n` pairwise
distances (where`n` is the number of records), and most importantly does not
require to measure the entire distance matrix.
"""
function thin(
    records::T,
    d::Float64
) where {T<:OccurrencesInterface.AbstractOccurrenceCollection}

    # Number of records
    n = length(records)

    # Radius for the search
    r = PseudoAbsences._window_size_in_degrees(d, records)

    # Track eligibility and removal
    eligible = BitVector(ones(Bool, n))
    removed = BitVector(zeros(Bool, n))

    while sum(eligible) > 0

        # From these, we pick a random focal sample
        focal = StatsBase.sample(findall(eligible))

        # We measure the window around this point
        lon_span = 1.015 * (d / (cos(place(records[focal])[2] * π / 180) * 111325.0 / 1000.0))
        lat_span = 1.015 * (d / (111325.0 / 1000.0))

        # The candidates for deletion are all the records in the boundingbox of the
        # point
        candidates = findall(
            e ->
                (abs(place(e)[1] - place(records[focal])[1]) <= lon_span) &
                (abs(place(e)[2] - place(records[focal])[2]) <= lat_span), elements(records)
        )

        eligible[focal] = false
        if length(candidates) > 1
            for candidate in candidates
                if candidate != focal
                    if eligible[candidate]
                        D = PseudoAbsences._distancefunction(place(records[candidate]), place(records[focal]))
                        if D <= d
                            removed[candidate] = true
                            eligible[candidate] = false
                        end
                    end
                end
            end
        end

    end

    return records[findall(.! removed)]
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