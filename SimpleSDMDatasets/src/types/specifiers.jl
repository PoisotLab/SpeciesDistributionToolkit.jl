"""
    RasterData{P <: RasterProvider, D <: RasterDataset}

The `RasterData` type is the main user-facing type for `SimpleSDMDatasets`.
Specifically, this is a *singleton* parametric type, where the two parameters
are the type of the `RasterProvider` and the `RasterDataset`. Note that the
inner constructor calls the `provides` method on the provider/dataset pair to
check that this combination exists.
"""
struct RasterData{P <: RasterProvider, D <: RasterDataset}
    provider::Type{P}
    dataset::Type{D}
    RasterData(P, D) =
        if ~SimpleSDMDatasets.provides(P, D)
            error("The $(D) dataset is not provided by $(P)")
        else
            new{P, D}(P, D)
        end
end

"""
    Future{S <: FutureScenario, M <: FutureModel}

This type is similar to `RasterData` but describes a combination of a scenario
and a model. Note that *unlike* `RasterData`, there is no type check in the
inner constructor; instead, the way to check that a
provider/dataset/scenario/model combination exists is to overload the `provides`
method for a dataset and future.
"""
struct Projection{S <: FutureScenario, M <: FutureModel}
    scenario::Type{S}
    model::Type{M}
end
