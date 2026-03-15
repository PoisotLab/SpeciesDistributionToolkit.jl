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

function OccurrencesInterface.Occurrences(model::AbstractBoostedSDM; kwargs...)
    return OccurrencesInterface.Occurrences(model.model; kwargs...)
end

function OccurrencesInterface.Occurrences(model::Bagging; kwargs...)
    return OccurrencesInterface.Occurrences(model.model; kwargs...)
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

@testitem "We can use the absences function on an SDM" begin
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    train!(model)
    @test length(OccurrencesInterface.absences(model)) == length(labels(model)) - sum(labels(model))
end
