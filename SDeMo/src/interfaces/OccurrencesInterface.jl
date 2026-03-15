function OccurrencesInterface.Occurrences(model::SDM; name = "")
    records = [
        OccurrencesInterface.Occurrence(
            name,
            l,
            isgeoreferenced(model) ? (model.coordinates[i]) : missing,
            missing,
        ) for (i, l) in enumerate(labels(model))]
    return OccurrencesInterface.Occurrences(records)
end

OccurrencesInterface.Occurrences(model::AbstractBoostedSDM; kwargs...) = Occurrences(model.model; kwargs...)
OccurrencesInterface.Occurrences(model::Bagging; kwargs...) = Occurrences(model.model; kwargs...)

@testitem "We can turn an SDM into a collection of Occurrences" begin
    using SDeMo.OccurrencesInterface
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    train!(model)
    @test Occurrences(model) isa Occurrences
end

OccurrencesInterface.presences(model::AbstractSDM) = OccurrencesInterface.presences(OccurrencesInterface.Occurrences(model))
OccurrencesInterface.absences(model::AbstractSDM) = OccurrencesInterface.absences(OccurrencesInterface.Occurrences(model))
OccurrencesInterface.elements(model::AbstractSDM) = OccurrencesInterface.elements(OccurrencesInterface.Occurrences(model))

@testitem "We can use the presences function on an SDM" begin
    using SDeMo.OccurrencesInterface
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    train!(model)
    @test length(OccurrencesInterface.presences(model)) == sum(labels(model))
end

@testitem "We can use the absences function on an SDM" begin
    using SDeMo.OccurrencesInterface
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    train!(model)
    @test length(absences(model)) == length(labels(model)) - sum(labels(model))
end

@testitem "We can set the name of the species when creating occurrences" begin
    using SDeMo.OccurrencesInterface
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    occ = Occurrences(model; name = "Sitta whiteheadi")
    @test entity(first(occ)) == "Sitta whiteheadi"
end

@testitem "We can get occurrences from a model without goespatial data" begin
    using SDeMo.OccurrencesInterface
    X, y, C = SDeMo.__demodata()
    model = SDM(RawData, NaiveBayes, X, y)
    occ = Occurrences(model; name = "Sitta whiteheadi")
    @test entity(first(occ)) == "Sitta whiteheadi"
    @test ismissing(place(first(occ)))
end
