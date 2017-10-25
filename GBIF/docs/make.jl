push!(LOAD_PATH, "../src/")

using Documenter, GBIF

makedocs(
    format = :html,
    sitename = "GBIF.jl",
    pages = [
        "Home" => "index.md",
        "Retrieving observations" => "occurrences.md",
        "Filtering observations" => "qaqc.md"
    ]
)
