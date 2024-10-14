using Documenter
using DocumenterVitepress
using GBIF

makedocs(;
    sitename="GBIF",
    format=DocumenterVitepress.MarkdownVitepress(
        repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl",
        devbranch="main",
        devurl="dev",
        deploy_url="SpeciesDistributionToolkit.jl/GBIF"
    ),
    modules=[GBIF],
    pages=[
        "GBIF.jl" => "index.md",
        "Data representation" => "types.md",
        "Data retrieval" => "data.md",
        "Enumerated query parameters" => "enums.md",
        "Internals" => "internals.md",
    ],
)

deploydocs(; repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    dirname="GBIF",
    tag_prefix="GBIF-",
    devbranch="main",
    push_preview=true,
)
