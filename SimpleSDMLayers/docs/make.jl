push!(LOAD_PATH, joinpath("..", "src"))

using Documenter, SimpleSDMLayers
using GBIF
using Statistics
using Literate

# Literate files
expl = joinpath("docs", "src", "examples")
corefiles = [joinpath(expl, f) for f in readdir(expl)]
filter!(f -> endswith(f, "jl"), corefiles)
vignetteconfig = Dict(
    "repo_root_url" => "https://github.com/EcoJulia/SimpleSDMLayers.jl",
    "flavor" => Literate.DocumenterFlavor(),
    "credit" => false
)
for corefile in corefiles
    Literate.markdown(corefile, expl; config=vignetteconfig)
end

makedocs(
    sitename = "Simple SDM Layers",
    modules = [SimpleSDMLayers],
    pages = [
        "Home" => "index.md",
        "Manual" => [
            "Types" => "man/types.md",
            "Indexing" => "man/indexing.md",
            "Clipping" => "man/clip.md",
            "Operations on values" => "man/changevalues.md",
            "Overloads" => "man/overloads.md",
            "Other operations" => "man/operations.md",
        ],
        "Data" => [
            "Data interface" => "data/index.md",
            "IO" => "data/io.md",
            "Providers" => "data/providers.md",
            "Datasets" => "data/datasets.md",
            "Futures" => "data/futuredata.md",
        ],
        "General examples" => [
            "Elevation data" => "examples/elevation.md",
            "Geometry objects" => "examples/geometry.md",
            "Sliding window analysis" => "examples/slidingwindow.md",
            "Landcover data" => "examples/landcover.md",
            "Landcover consensus" => "examples/consensus.md",
            "Importing and exporting" => "examples/import.md",
        ],
        "SDM examples" => [
            "GBIF integration" => "examples/gbif.md",
            "Building the BIOCLIM model" => "examples/bioclim.md",
            "Pseudo-absences" => "examples/pseudoabsences.md",
            "Dealing with future data" => "examples/future.md",
            "BRTs and climate change" => "examples/brt.md"
        ]
    ]
)

run(`find . -type f -size +40M -delete`)

deploydocs(
    repo = "github.com/EcoJulia/SimpleSDMLayers.jl.git",
    push_preview = true
)
