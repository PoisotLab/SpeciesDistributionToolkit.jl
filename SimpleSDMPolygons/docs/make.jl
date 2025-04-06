using Documenter
using SimpleSDMPolygons

makedocs(
    sitename="SimpleSDMPolygons",
    format=Documenter.HTML(),
    modules=[SimpleSDMPolygons],
    pages=[
        "index.md"
    ],
)

deploydocs(; repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    dirname="SimpleSDMPolygons",
    tag_prefix="SimpleSDMPolygons-",
    devbranch="main",
    push_preview=true,
)
