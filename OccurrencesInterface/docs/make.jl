using Documenter
using OccurrencesInterface

makedocs(
    sitename="OccurrencesInterface",
    format=Documenter.HTML(),
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
