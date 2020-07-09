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
            "Types" => "types.md"
        ],
        "Examples" => [
            "Northern cardinal" => "examples/cardinal.md",
            "Bats rank-abundance" => "examples/bats.md"
        ],
        "Code performance" => [
            "Traceur results" => "benchmark/traceur.md",
            "Benchmark" => "benchmark/benchmark.md"
        ]
    ]
)

deploydocs(
    repo = "github.com/EcoJulia/GBIF.jl.git",
    push_preview = true
)
