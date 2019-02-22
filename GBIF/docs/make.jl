push!(LOAD_PATH, "../src/")

using Documenter, GBIF

makedocs(
    modules = [GBIF],
    pages = [
        "Home" => "index.md",
        "Occurrences" => "occurrences.md",
        "Queries" => "queries.md",
        "Filtering records" => "qaqc.md"
    ]
)

deploydocs(
    repo = "github.com/EcoJulia/GBIF.jl.git"
)
