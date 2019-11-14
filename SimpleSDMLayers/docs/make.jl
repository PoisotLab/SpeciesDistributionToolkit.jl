push!(LOAD_PATH, joinpath("..", "src"))

using Documenter, SimpleSDMLayers

makedocs(
    sitename = "Simple SDM Layers",
    modules = [SimpleSDMLayers],
    pages = [
        "Manual" => [
            "Types" => "man/types.md"
        ]
    ]
)

deploydocs(
    repo = "github.com/EcoJulia/SimpleSDMLayers.jl.git"
)
