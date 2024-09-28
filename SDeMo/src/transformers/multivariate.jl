# Types to fit
types_to_train = [:PCA, :PPCA, :KernelPCA, :Whitening]
types_with_transform = [:Whitening]

"""
    MultivariateTransform{T} <: Transformer

`T` is a multivariate transformation, likely offered through the
`MultivariateStats` package. The transformations currently supported are `PCA`,
`PPCA`, `KernelPCA`, and `Whitening`.
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
