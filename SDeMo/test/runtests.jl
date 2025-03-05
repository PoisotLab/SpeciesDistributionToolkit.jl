using TestItemRunner

@run_package_tests filter=ti->!(:skipci in ti.tags)

@testitem "We can set hyper-parameters for a full model" begin
    X, y = SDeMo.__demodata()
    X, y = SDeMo.__demodata()
    sdm = SDM(ZScore(), Logistic(), 0.5, X, y, 1:size(X,1))
    hyperparameters!(classifier(sdm), :epochs, 10_000)
    hyperparameters!(classifier(sdm), :λ, 0.15)
    hyperparameters!(classifier(sdm), :interactions, :none)
    train!(sdm)
    @test hyperparameters(classifier(sdm), :λ) == 0.15
end