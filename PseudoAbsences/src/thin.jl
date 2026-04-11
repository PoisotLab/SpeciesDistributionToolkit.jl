"""
    thin( records::T, d::Float64; nmin::Integer = 30, ) where {T <: AbstractOccurrenceCollection}

Returns a spatially thinned collection of occurrences so that no points are
closer than `d` kilometers from one another. The `nmin` keyword (default to 30)
can also be set to ensure that there are at least that many points, regardless
of the distance between points at the end.
"""
function thin(
    records::T,
    d::Float64;
    nmin::Integer = 30,
) where {T <: OccurrencesInterface.AbstractOccurrenceCollection}
    D = fill(Inf16, length(records), length(records))
    
    # We fill the distances but ONLY for the pairs of points that are closer
    # than the threshold - the rest of the points do not matter
    for i in axes(D, 1)
        for j in axes(D, 2)
            if j > i
                dᵢⱼ = PseudoAbsences._distancefunction(place(records[i]), place(records[j]))
                if dᵢⱼ <= d
                    D[i, j] = dᵢⱼ
                end
            end
        end
    end

    candidates = dropdims(mapslices(x -> !all(isinf, x), D; dims = 1); dims = 1)
    max_iter = length(candidates) - nmin
    counter = 0

    while (minimum(D) <= d) & (counter < max_iter)
        counter += 1
        min_idx = last(findmin(D))
        removed = rand(min_idx.I)
        D[removed, :] .= Inf
        D[:, removed] .= Inf
    end

    retained = dropdims(mapslices(x -> !all(isinf, x), D; dims = 1); dims = 1)
    kept = findall(retained .| (.! candidates))

    return records[kept]
end

@testitem "We can spatially thin the reduced demo dataset" begin
    using PseudoAbsences.OccurrencesInterface
    records = OccurrencesInterface.__demodata()
    records = Occurrences(filter(
        e ->
            (-130. <= place(e)[1] <= -110.) &
            (30. <= place(e)[2] <= 50.)
        , elements(records)
    ))

    thinned = thin(records, 150.)
    @test length(thinned) < length(records)
end