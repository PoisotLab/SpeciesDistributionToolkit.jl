using Documenter
using DocumenterVitepress
using Statistics
using SimpleSDMLayers

makedocs(;
    sitename="SimpleSDMLayers",
    format=DocumenterVitepress.MarkdownVitepress(
        repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl",
        devbranch="main",
        devurl="dev",
        deploy_url="SpeciesDistributionToolkit.jl/SimpleSDMLayers"
    ),
    warnonly=true,
    modules=[SimpleSDMLayers],
    pages=[
        "index.md",
        "types.md",
        "operations.md",
    ],
)

deploydocs(; repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    dirname="SimpleSDMLayers",
    tag_prefix="SimpleSDMLayers-",
    devbranch="main",
    push_preview=true,
)
