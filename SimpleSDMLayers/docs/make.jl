push!(LOAD_PATH, joinpath("..", "src"))

using Documenter, SimpleSDMLayers

makedocs(
    sitename = "Simple SDM Layers",
    modules = [SimpleSDMLayers],
    pages = [
        "Simple SDM Layers" => "index.md",
        "Manual" => [
            "Types" => "man/types.md",
            "Overloads" => "man/overloads.md"
        ]
    ]
)

deploydocs(
    repo = "github.com/EcoJulia/SimpleSDMLayers.jl.git"
)
