using Documenter
using SDeMo

makedocs(
    sitename="SDeMo",
    format=Documenter.HTML(),
    modules=[SDeMo],
    pages=[
        "index.md",
    ],
)

deploydocs(; repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    dirname="SDeMo",
    tag_prefix="SDeMo-",
    devbranch="main",
    push_preview=true,
)
