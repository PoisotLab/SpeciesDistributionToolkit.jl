# Make sure we work from the version in the repo
sdt_path = dirname(dirname(Base.current_project()))
push!(LOAD_PATH, sdt_path)
using SpeciesDistributionToolkit

# Load the rest of the build environment
using Documenter
using DocumenterVitepress
using Literate
using Markdown
using InteractiveUtils
using Dates

# Generate a report card for each known dataset
include("dataset_report.jl")

# Render the tutorials and how-to using Literate
for folder in ["howto", "tutorials"]
    fpath = joinpath(@__DIR__, "src", folder)
    for docfile in filter(endswith(".jl"), readdir(fpath; join=true))
        Literate.markdown(
            docfile, fpath;
            flavor = Literate.DocumenterFlavor(),
            config = Dict("credit" => false, "execute" => true),
        )
    end
end

makedocs(;
    sitename = "Species Distribution Toolkit",
    format = MarkdownVitepress(;
        repo = "https://github.com/PoisotLab/SpeciesDistributionToolkit.jl",
    ),
    warnonly = true,
    pages = [
        "Manual" => "manual.md",
        "Tutorials" => [
            "tutorials/arithmetic.md",
            "tutorials/statistics.md",
            "tutorials/consensus.md",
            "tutorials/layers_and_occurrences.md",
            "tutorials/bioclim.md",
            "tutorials/polygons.md",
            "tutorials/pseudoabsences.md",
            "tutorials/fauxcurrences.md",
            "tutorials/futureclimate.md",
            "tutorials/zonal.md",
        ],
        "How-to..." => [
            "howto/get_gbif_data.md",
            "howto/know_layers_provided.md",
            "howto/mask_a_layer.md",
            "howto/split_a_layer.md",
            "howto/interpolate.md",
            "howto/makie.md",
        ],
        "Documentation" => [
            "Work with species occurrence data" => "manual/SpeciesDistributionToolkit/index.md",
            "Occurrences and layers" => "manual/SpeciesDistributionToolkit/gbif.jl.md",
            "Pseudo-absences" => "manual/SpeciesDistributionToolkit/pseudoabsences.md",
        ]
    ],
)

deploydocs(;
    repo = "github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    devbranch = "main",
    push_preview = true,
)
