using Documenter
using DocumenterVitepress
using Phylopic

makedocs(
    sitename="Phylopic",
    format=DocumenterVitepress.MarkdownVitepress(
        repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl",
        devbranch="main",
        devurl="dev",
        deploy_url="SpeciesDistributionToolkit.jl/Phylopic"
    ),
    modules=[Phylopic],
    pages=[
        "Phylopic.jl" => "index.md",
        "Internals" => "internals.md",
    ],
)

deploydocs(; repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    dirname="Phylopic",
    tag_prefix="Phylopic-",
    devbranch="main",
    push_preview=true,
)
