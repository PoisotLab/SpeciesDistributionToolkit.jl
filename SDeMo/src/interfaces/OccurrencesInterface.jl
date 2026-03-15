function OccurrencesInterface.Occurrences(model::AbstractSDM; name="NONAME")
    records = OccurrencesInterface.Occurrence[]
    for i in eachindex(labels(model))
        push!(records, OccurrencesInterface.Occurrence(
            name,
            labels(model)[i],
            isgeoreferenced(model) ? (model.coordinates[i]) : missing,
            missing
        ))
    end
    return OccurrencesInterface.Occurrences(records...)
end

@testitem "We can turn an SDM into a collection of Occurrences" begin
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    train!(model)
    @test Occurrences(model) isa OccurrencesInterface.Occurrences
end

function OccurrencesInterface.presences(model::AbstractSDM)
    records = OccurrencesInterface.Occurrences(model)
    return OccurrencesInterface.presences(records)
end

function OccurrencesInterface.absences(model::AbstractSDM)
    records = OccurrencesInterface.Occurrences(model)
    return OccurrencesInterface.absences(records)
end

function OccurrencesInterface.elements(model::AbstractSDM)
    records = OccurrencesInterface.Occurrences(model)
    return OccurrencesInterface.elements(records)
end

@testitem "We can use the presences function on an SDM" begin
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    train!(model)
    @test length(OccurrencesInterface.presences(model)) == sum(labels(model))
end
