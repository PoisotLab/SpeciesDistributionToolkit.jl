push!(LOAD_PATH, "../src/")

using Documenter, GBIF

makedocs(
    sitename = "GBIF wrapper in Julia",
    authors = "Timothée Poisot",
    modules = [GBIF],
    pages = [
        "Home" => "index.md",
        "Data" => [
            "Occurrences" => "occurrences.md",
            "Taxa" => "taxa.md"
        ],
        "Queries" => "queries.md",
        "Filtering records" => "qaqc.md"
    ]
)

deploydocs(
    repo = "github.com/EcoJulia/GBIF.jl.git"
)
