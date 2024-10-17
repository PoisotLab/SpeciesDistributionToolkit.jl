# Types to fit
types_to_train = [:PCA, :PPCA, :KernelPCA, :Whitening]
types_with_transform = [:Whitening]

"""
    MultivariateTransform{T} <: Transformer

`T` is a multivariate transformation, likely offered through the
`MultivariateStats` package. The transformations currently supported are `PCA`,
`PPCA`, `KernelPCA`, and `Whitening`, and they are documented through their type aliases (*e.g.* `PCATransform`).
"""
Base.@kwdef mutable struct MultivariateTransform{T} <: Transformer
    trf::T = StatsAPI.fit(T, Matrix(LinearAlgebra.I(2) .* 1.0))
end

for tf in types_to_train
    fitpkg = tf in types_with_transform ? :MultivariateStats : :StatsAPI
    fitfunc = tf in types_with_transform ? :transform : :predict
    eval(
        quote
            function train!(trf::MultivariateTransform{$tf}, X; kwdef...)
                return trf.trf = StatsAPI.fit(MultivariateStats.$tf, X)
            end
            function StatsAPI.predict(
                trf::MultivariateTransform{$tf},
                x::AbstractArray;
                kwdef...,
            )
                return $(fitpkg).$(fitfunc)(trf.trf, x)
            end
        end,
    )
end

"""
    PCATransform

The PCA transform will project the model features, which also serves as a way to decrease the dimensionality of the problem. Note that this method will only use the training instances, and unless the `absences=true` keyword is used, only the present cases. This ensure that there is no data leak (neither validation data nor the data from the raster are used).

This is an alias for `MultivariateTransform{PCA}`.
"""
const PCATransform = MultivariateTransform{PCA}
const PPCATransform = MultivariateTransform{PPCA}

"""
    WhiteningTransform

The whitening transformation is a linear transformation of the input variables, after which the new variables have unit variance and no correlation. The input is transformed into white noise.

Because this transform will usually keep the first variable "as is", and then apply increasingly important perturbations on the subsequent variables, it is sensitive to the order in which variables are presented, and is less useful when applying tools for interpretation.

This is an alias for `MultivariateTransform{Whitening}`.
"""
const WhiteningTransform = MultivariateTransform{Whitening}
const kPCATransform = MultivariateTransform{KernelPCA}
export PCATransform, PPCATransform, kPCATransform, WhiteningTransform

@testitem "We can declare a model with a type alias" begin
    X, y = SDeMo.__demodata()
    model = SDM(PCATransform, NaiveBayes, X, y)
    @test typeof(transformer(model)) === MultivariateTransform{PCA}
end
