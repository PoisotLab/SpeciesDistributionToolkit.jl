push!(LOAD_PATH, "../src/")

using Documenter, GBIF

makedocs(
    sitename = "GBIF wrapper in Julia",
    authors = "Timothée Poisot",
    modules = [GBIF],
    pages = [
        "Home" => "index.md",
        "Getting data" => [
            "Taxa" => "taxa.md",
            "Occurrences" => "occurrences.md",
            "Queries" => "queries.md",
            "Filtering records" => "qaqc.md"
        ],
        "Types" => "types.md"
    ]
)

deploydocs(
    repo = "github.com/EcoJulia/GBIF.jl.git"
)
