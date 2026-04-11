function Dᵢⱼ(records)
    D = fill(Inf16, length(records), length(records))

    for i in axes(D, 1)
        for j in axes(D, 2)
            if j > i
                dᵢⱼ = PseudoAbsences._distancefunction(place(records[i]), place(records[j]))
                D[j, i] = D[i, j] = dᵢⱼ
            end
        end
    end

    return D
end

"""
    thin( records::T, d::Float64; nmin::Integer = 30, ) where {T <: AbstractOccurrenceCollection}

Returns a spatially thinned collection of occurrences so that no points are
closer than `d` kilometers from one another. The `nmin` keyword (default to 30)
can also be set to ensure that there are at least that many points, regardless
of the distance between points at the end. If there are fewer than `nmin` points
at the specified distance, the minimum distance will be changed to allow points
that are closer, until the `nmin` condition is met.
"""
function thin(
    records::T,
    d::Float64;
    nmin::Integer=30,
) where {T<:OccurrencesInterface.AbstractOccurrenceCollection}

    D = Dᵢⱼ(records)

    too_close = D .< d
    n_violations = vec(sum(too_close, dims=1))
    while count(iszero, n_violations) < nmin
        d *= 0.99
        too_close = D .< d
        n_violations = vec(sum(too_close, dims=1))
    end

    kept = findall(iszero, n_violations)
    return records[kept]
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

    @test minimum(Dᵢⱼ(records)) == Float16(0.0)

    thinned = thin(records, 25.)
    
    @test minimum(Dᵢⱼ(thinned)) >= Float16(25.)
end