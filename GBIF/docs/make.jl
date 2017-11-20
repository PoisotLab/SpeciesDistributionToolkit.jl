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

deploydocs(
    deps   = Deps.pip("mkdocs", "python-markdown-math"),
    repo = "github.com/EcoJulia/GBIF.jl.git",
    julia = "0.6",
    osname = "linux"
)
