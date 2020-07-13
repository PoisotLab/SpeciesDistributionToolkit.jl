push!(LOAD_PATH, joinpath("..", "src"))

using Documenter, SimpleSDMLayers
using GBIF
using Statistics

makedocs(
    sitename = "Simple SDM Layers",
    modules = [SimpleSDMLayers],
    pages = [
        "Home" => "index.md",
        "Manual" => [
            "Types" => "man/types.md",
            "Overloads" => "man/overloads.md",
            "Other operations" => "man/operations.md",
            "Data" => "man/data.md",
            "Plotting" => "man/plotting.md"
        ],
        "Examples" => [
            "Temperature data" => "examples/temperature.md",
            "GBIF integration" => "examples/gbif.md",
            "Sliding window analysis" => "examples/slidingwindow.md",
            "Landcover" => "examples/landcover.md"
        ]
    ]
)

deploydocs(
    repo = "github.com/EcoJulia/SimpleSDMLayers.jl.git",
    push_preview = true
)
