function Occurrences(model::AbstractSDM; name="NONAME")
    records = Occurrence[]
    for i in eachindex(labels(model))
        push!(records, Occurrence(
            name,
            labels(model)[i],
            isgeoreferenced(model) ? (model.coordinates[i]) : missing,
            missing
        ))
    end
    return Occurrences(records...)
end

function Occurrences(model::AbstractBoostedSDM; kwargs...)
    return Occurrences(model.model; kwargs...)
end

function Occurrences(model::Bagging; kwargs...)
    return Occurrences(model.model; kwargs...)
end

@testitem "We can turn an SDM into a collection of Occurrences" begin
    using OccurrencesInterface
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    train!(model)
    @test OccurrencesInterface.Occurrences(model) isa Occurrences
end

function presences(model::AbstractSDM)
    records = Occurrences(model)
    return presences(records)
end

function absences(model::AbstractSDM)
    records = Occurrences(model)
    return OccurrencesInterface.absences(records)
end

function elements(model::AbstractSDM)
    records = Occurrences(model)
    return elements(records)
end

@testitem "We can use the presences function on an SDM" begin
    using OccurrencesInterface
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    train!(model)
    @test length(presences(model)) == sum(labels(model))
end

@testitem "We can use the absences function on an SDM" begin
    import OccurrencesInterface
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    train!(model)
    @test length(absences(model)) == length(labels(model)) - sum(labels(model))
end

@testitem "We can set the name of the species when creating occurrences" begin
    using OccurrencesInterface
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    occ = Occurrences(model; name="Sitta whiteheadi")
    @test entity(first(occ)) == "Sitta whiteheadi"
end

@testitem "We can get occurrences from a model without goespatial data" begin
    using OccurrencesInterface
    X, y, C = SDeMo.__demodata()
    model = SDM(RawData, NaiveBayes, X, y)
    occ = Occurrences(model; name="Sitta whiteheadi")
    @test entity(first(occ)) == "Sitta whiteheadi"
    @test ismissing(place(first(occ)))
end
