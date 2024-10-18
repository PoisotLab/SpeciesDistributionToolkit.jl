using Documenter
using Phylopic

makedocs(
    sitename="Phylopic",
    format=Documenter.HTML(),
    modules=[Phylopic],
    pages=[
        "index.md",
    ],
)

deploydocs(; repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    dirname="Phylopic",
    tag_prefix="Phylopic-",
    devbranch="main",
    push_preview=true,
)
