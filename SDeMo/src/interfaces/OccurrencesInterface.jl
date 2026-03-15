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
    import OccurrencesInterface
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    train!(model)
    @test OccurrencesInterface.Occurrences(model) isa OccurrencesInterface.Occurrences
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
    OccurrencesInterface
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    train!(model)
    @test length(OccurrencesInterface.presences(model)) == sum(labels(model))
end

@testitem "We can use the absences function on an SDM" begin
    import OccurrencesInterface
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    train!(model)
    @test length(OccurrencesInterface.absences(model)) == length(labels(model)) - sum(labels(model))
end

@testitem "We can set the name of the species when creating occurrences" begin
    import OccurrencesInterface
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    occ = OccurrencesInterface.Occurrences(model; name="Sitta whiteheadi")
    @test OccurrencesInterface.entity(first(occ)) == "Sitta whiteheadi"
end

@testitem "We can get occurrences from a model without goespatil data" begin
    import OccurrencesInterface
    X, y, C = SDeMo.__demodata()
    model = SDM(RawData, NaiveBayes, X, y)
    occ = OccurrencesInterface.Occurrences(model; name="Sitta whiteheadi")
    @test OccurrencesInterface.entity(first(occ)) == "Sitta whiteheadi"
    @test ismissing(OccurrencesInterface.place(first(occ)))
end
