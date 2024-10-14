using Documenter
using DocumenterVitepress
using OccurrencesInterface

makedocs(
    sitename="OccurrencesInterface",
    format=DocumenterVitepress.MarkdownVitepress(
        repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl",
        devbranch="main",
        devurl="dev",
        deploy_url="https://poisotlab.github.io/SpeciesDistributionToolkit.jl/OccurrencesInterface/"
    ),
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
