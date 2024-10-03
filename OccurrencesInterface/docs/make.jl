using Documenter
using OccurrencesInterface
using CairoMakie

makedocs(
    sitename="OccurrencesInterface",
    format=Documenter.HTML(size_threshold_ignore=["demo.md"]),
    modules=[OccurrencesInterface],
    pages=[
        "index.md",
    ],
)

deploydocs(; repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    dirname="OccurrencesInterface",
    tag_prefix="OccurrencesInterface-",
    devbranch="main",
    push_preview=true,
)
