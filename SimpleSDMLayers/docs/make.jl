push!(LOAD_PATH, joinpath("..", "src"))

using Documenter, SimpleSDMLayers
using GBIF
using Statistics
using Literate

# Literate files
for ENDING in ["examples", "sdm"]
    expl = joinpath("docs", "src", ENDING)
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
            "Multivariate mapping" => "examples/multivariate.md"
        ],
        "SDM case studies" => [
            "GBIF integration" => "sdm/gbif.md",
            "Variable selection (VIF)" => "sdm/vif.md",
            "Building the BIOCLIM model" => "sdm/bioclim.md",
            "Pseudo-absences" => "sdm/pseudoabsences.md",
            "Dealing with future data" => "sdm/future.md",
            "BRTs and climate change" => "sdm/brt.md"
        ]
    ]
)

run(`find . -type f -size +5M -delete`)

deploydocs(
    repo = "github.com/EcoJulia/SimpleSDMLayers.jl.git",
    push_preview = true,
    devbranch = "main"
)
