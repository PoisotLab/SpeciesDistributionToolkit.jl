using Documenter
using GBIF

makedocs(;
    sitename="GBIF",
    format=Document.HTML(
        repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl",
        devbranch="main",
        devurl="dev",
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
