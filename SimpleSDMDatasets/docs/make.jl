using Documenter
using DocumenterVitepress
using SimpleSDMDatasets

makedocs(;
    sitename="SimpleSDMDatasets",
    format=DocumenterVitepress.MarkdownVitepress(
        repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl",
        devbranch="main",
        devurl="dev",
        deploy_url="SpeciesDistributionToolkit.jl/SimpleSDMDatasets"
    ),
    modules=[SimpleSDMDatasets],
    pages=[
        "Index" => "index.md",
        "Interface" => "interface.md",
        "Types" => "types.md",
        "Internals" => "internals.md",
    ],
)

deploydocs(; repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    dirname="SimpleSDMDatasets",
    tag_prefix="SimpleSDMDatasets-",
    devbranch="main",
    push_preview=true,
)
