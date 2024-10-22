using Documenter
using SimpleSDMDatasets

makedocs(;
    sitename="SimpleSDMDatasets",
    format=Documenter.HTML(),
    modules=[SimpleSDMDatasets],
    pages=[
        "index.md"
    ],
)

deploydocs(; repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    dirname="SimpleSDMDatasets",
    tag_prefix="SimpleSDMDatasets-",
    devbranch="main",
    push_preview=true,
)
