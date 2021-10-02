push!(LOAD_PATH, joinpath("..", "src"))

using Documenter, SimpleSDMLayers
using GBIF
using Statistics
using Literate

# Literate files
corefiles = [joinpath(joinpath("src", "examples"), f) for f in readdir(joinpath("src", "examples"))]
filter!(f -> endswith(f, "jl"), corefiles)
vignetteconfig = Dict(
    "repo_root_url" => "https://github.com/EcoJulia/SimpleSDMLayers.jl",
    "flavor" => Literate.DocumenterFlavor(),
    "credit" => false
)
for corefile in corefiles
    Literate.markdown(corefile; config=vignetteconfig)
end

makedocs(
    sitename = "Simple SDM Layers",
    modules = [SimpleSDMLayers],
    pages = [
        "Home" => "index.md",
        "Manual" => [
            "Types" => "man/types.md",
            "Indexing" => "man/indexing.md",
            "Overloads" => "man/overloads.md",
            "Other operations" => "man/operations.md",
            "Data" => "man/data.md",
        ],
        "General examples" => [
            "Temperature data" => "examples/temperature.md",
            "DataFrames integration" => "examples/dataframes.md",
            "Sliding window analysis" => "examples/slidingwindow.md",
            "Landcover data" => "examples/landcover.md",
            "Landcover consensus" => "examples/consensus.md",
            "Importing and exporting" => "examples/import.md",
        ],
        "SDM examples" => [
            "GBIF integration" => "examples/gbif.md",
            "BIOCLIM from scratch" => "examples/bioclim.md",
            "Future data" => "examples/future.md"
        ]
    ]
)

run(`find . -type f -size +40M -delete`)

deploydocs(
    repo = "github.com/EcoJulia/SimpleSDMLayers.jl.git",
    push_preview = true
)
