using Documenter
using GBIF

makedocs(;
    sitename="GBIF",
    format=Documenter.HTML(),
    modules=[GBIF],
    pages=[
        "index.md",
    ],
)

deploydocs(; repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    dirname="GBIF",
    tag_prefix="GBIF-",
    devbranch="main",
    push_preview=true,
)
