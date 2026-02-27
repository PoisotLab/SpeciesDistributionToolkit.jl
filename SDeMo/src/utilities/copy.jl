Base.copy(model::T) where {T <: AbstractSDM} = deepcopy(model)

function Base.copy(model::T)
    return SDM(
        copy(classifier(model)),
        copy(transformer(model)),
        threshold(model),
        copy(features(model)),
        copy(labels(model)),
        copy(variables(model)),
        copy(coordinates(model)),
        istrained(model)
    )
end

@testitem "We can copy a SDM" begin
    model = SDM(RawData, ZScore, SDeMo.__demodata()...)
    cp = copy(model)
    @test istrained(cp) == false
    @test isgeoreferenced(cp) == true
    train!(model)
    @test !istrained(cp)
    cp = copy(model)
    @test istrained(cp)
    pr_orig = predict(model, threshold=false)
    pr_copy = predict(cp, threshold=false)
    for i in eachindex(pr_orig)
        @test pr_orig[i] == pr_copy[i]
    end
end