using TestItemRunner

@run_package_tests filter=ti->!(:skipci in ti.tags)

@testitem "We can set hyper-parameters for a full model" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(ZScore(), Logistic(), 0.5, X, y, 1:size(X,1))
    hyperparameters!(classifier(sdm), :epochs, 10_000)
    hyperparameters!(classifier(sdm), :λ, 0.15)
    hyperparameters!(classifier(sdm), :interactions, :none)
    train!(sdm)
    @test hyperparameters(classifier(sdm), :λ) == 0.15
end

@testitem "We can run a decision stump (it works fr fr)" begin
    X, y = SDeMo.__demodata()
    stump = SDM(RawData, DecisionTree, X, y)
    hyperparameters!(classifier(stump), :maxdepth, 1)
    hyperparameters!(classifier(stump), :maxnodes, 2)
    train!(stump)
    @test sum(predict(stump)) < length(y)
end