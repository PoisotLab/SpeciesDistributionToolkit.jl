Base.copy(model::T) where {T <: AbstractSDM} = deepcopy(model)

function Base.copy(model::SDM)
    return SDM(
        deepcopy(transformer(model)),
        deepcopy(classifier(model)),
        threshold(model),
        copy(features(model)),
        copy(labels(model)),
        copy(variables(model)),
        copy(model.coordinates),
        istrained(model)
    )
end

@testitem "We can copy a SDM" begin
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
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

@testitem "We can train a copied SDM without affecting the original" begin
    model = SDM(RawData, NaiveBayes, SDeMo.__demodata()...)
    cp = copy(model)
    cp.y = [!l for l in cp.y]
    train!(cp)
    train!(model)
    pr_orig = predict(model, threshold=false)
    pr_copy = predict(cp, threshold=false)
    for i in eachindex(pr_orig)
        @test pr_orig[i] != pr_copy[i]
    end
end