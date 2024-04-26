using Documenter
using GBIF

makedocs(;
    sitename = "GBIF",
    format = Documenter.HTML(),
    modules = [GBIF],
    pages = [
        "GBIF.jl" => "index.md",
        "Data representation" => "types.md",
        "Data retrieval" => "data.md",
        "Enumerated query parameters" => "enums.md",
        "Internals" => "internals.md",
    ],
)

deploydocs(; repo = "github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    dirname = "GBIF",
    tag_prefix = "GBIF",
    devbranch = "main",
    push_preview = true,
)