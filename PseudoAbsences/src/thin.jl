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

    # Track eligibility and removal. An eligible point is one that can be
    # visited by the algorithm at a future iteration. A removed point has
    # already been found to be too close to an eligible point, and will not be
    # visited.
    eligible = BitVector(ones(Bool, n))
    removed = BitVector(zeros(Bool, n))

    # While there is at least one relevant point to visit...
    while sum(eligible) > 0

        # We pick a random eligible point.
        focal = StatsBase.sample(findall(eligible))

        # We measure the window around this point. This is a conversion from
        # kilometers to degree, and accounts for the latitude of the point. This
        # step is important because we want to measure as little distance pairs
        # as possible, and so we will look at points only within this bounding
        # box around the candidate.
        lon_span = 1.015 * (d / (cos(place(records[focal])[2] * π / 180) * 111325.0 / 1000.0))
        lat_span = 1.015 * (d / (111325.0 / 1000.0))

        # We remove the focal point from the pool of eligible points
        eligible[focal] = false
        pf = place(records[focal])

        # This is the main loop        
        for i in eachindex(eligible)
            if eligible[i] & (i != focal)
              
                # We can skip over non-eligible points because, when a point is
                # marked as removed, it is also removed from the pool of
                # eligible points.
                pl = place(records[i])
              
                # This checks whether the point is within the boundingbox.
                in_lon = abs(pl[1] - pf[1]) <= lon_span
                in_lat = abs(pl[2] - pf[2]) <= lat_span
              
                # If both are true, we calculate the distance, and remove the
                # points as needed
                if in_lon & in_lat
                    D = PseudoAbsences._distancefunction(pl, place(records[focal]))
                    if D <= d
                        removed[i] = true
                        eligible[i] = false
                    end
                end
            end
        end
    end

    return records[findall(.!removed)]
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

    n = length(thinned)
    for i in 1:(n-1)
        for j in (i+1):n
            d = PseudoAbsences._distancefunction(place(thinned[i]), place(thinned[j]))
            @test d >= 25.
        end
    end
end

@testitem "We do not lose clusters of overlapping points when thinning" begin
    using PseudoAbsences.OccurrencesInterface
    cluster1 = [Occurrence(where=(0.0, 0.0)) for _ in Base.OneTo(10)]
    cluster2 = [Occurrence(where=(90., 90.)) for _ in Base.OneTo(10)]
    records = Occurrences([cluster1; cluster2])

    thinned = thin(records, 25.)
    @test length(thinned) == 2
end