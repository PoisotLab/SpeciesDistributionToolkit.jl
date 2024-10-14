using Documenter
using DocumenterVitepress
using Fauxcurrences

makedocs(
    sitename="Fauxcurrences",
    format=DocumenterVitepress.MarkdownVitepress(
        repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl",
        devbranch="main",
        devurl="dev",
        deploy_url="SpeciesDistributionToolkit.jl/Fauxcurrences"
    ),
    modules=[Fauxcurrences],
    pages=[
        "Fauxcurrences.jl" => "index.md",
    ],
)

deploydocs(; repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    dirname="Fauxcurrences",
    tag_prefix="Fauxcurrences-",
    devbranch="main",
    push_preview=true,
)
