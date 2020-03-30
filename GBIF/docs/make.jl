push!(LOAD_PATH, "../src/")

using Documenter, GBIF

makedocs(
    sitename = "GBIF occurrences API wrapper in Julia",
    authors = "Timothée Poisot",
    modules = [GBIF],
    pages = [
        "Home" => "index.md",
        "Manual" => [
            "Getting data" => "data.md",
            "Filtering records" => "filter.md"
        ],
        "Types" => "types.md"
    ]
)

deploydocs(
    repo = "github.com/EcoJulia/GBIF.jl.git",
    push_preview = true
)
