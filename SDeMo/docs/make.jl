using Documenter
using SDeMo
using Literate
using CairoMakie


# Render the tutorials and how-to using Literate
for vignette in ["demo.jl"]
    fpath = joinpath(@__DIR__, "src", folder)
    Literate.markdown(
        docfile, fpath;
        flavor=Literate.DocumenterFlavor(),
        config=Dict("credit" => false, "execute" => true),
    )
end


makedocs(
    sitename="SDeMo",
    format=Documenter.HTML(),
    modules=[SDeMo],
    pages=[
        "index.md",
        "models.md",
        "crossvalidation.md",
        "features.md",
        "explanations.md",
        "ensembles.md",
        "saving.md",
        "demo.md"
    ],
)

deploydocs(; repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    dirname="SDeMo",
    tag_prefix="SDeMo-",
    devbranch="main",
    push_preview=true,
)