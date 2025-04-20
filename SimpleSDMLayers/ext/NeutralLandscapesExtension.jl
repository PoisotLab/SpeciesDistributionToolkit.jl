module NeutralLandscapesExtension

    using SimpleSDMLayers
    using NeutralLandscapes
    
    function SimpleSDMLayers.SDMLayer(nlm::T, s; kwargs...) where {T <: NeutralLandscapes.NeutralLandscapeMaker}
        N = rand(nlm, s)
        return SimpleSDMLayers.SDMLayer(N; kwargs...)
    end

    function SimpleSDMLayers.SDMLayer(nlm::T, tmpl::S; kwargs...) where {T <: NeutralLandscapes.NeutralLandscapeMaker, S <: SimpleSDMLayers.SDMLayer}
        X = similar(tmpl, Float64)
        rand!(X.grid, nlm)
        return X
    end

end