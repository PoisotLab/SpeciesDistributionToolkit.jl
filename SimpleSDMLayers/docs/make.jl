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
            "Data access" => "man/data.md",
            "IO" => "man/io.md"
        ],
        "General examples" => [
            "Introduction: elevation data" => "examples/elevation.md",
            "Geometry for clipping" => "examples/geometry.md",
            "Sliding window analysis" => "examples/slidingwindow.md",
            "Landcover data" => "examples/landcover.md",
            "Bivariate mapping" => "examples/bivariate.md"
        ],
        "SDM case studies" => [
            "GBIF integration" => "examples/gbif.md",
            "Variable selection (VIF)" => "examples/vif.md",
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
