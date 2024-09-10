# Make sure we work from the version in the repo
sdt_path = dirname(dirname(Base.current_project()))
push!(LOAD_PATH, sdt_path)
using SpeciesDistributionToolkit

# Load the rest of the build environment
using Documenter
using Markdown
using InteractiveUtils
using Dates

# Generate a report card for each known dataset
include("dataset_report.jl")

makedocs(;
    sitename = "Species Distribution Toolkit",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", nothing) == true,
    ),
    warnonly = true,
    pages = [
        "Index" => "index.md",
        "Tutorials" => [
            "tutorials/arithmetic.md",
            "tutorials/statistics.md",
            "tutorials/consensus.md",
            "tutorials/futureclimate.md",
            "tutorials/fauxcurrences.md",
        ],
        "How-to..." => [
            "howto/get_gbif_data.md",
            "howto/know_layers_provided.md",
            "howto/mask_a_layer.md",
            "howto/split_a_layer.md",
        ],
        "Documentation" => [
            "Work with species occurrence data" => "manual/SpeciesDistributionToolkit/index.md",
            "Occurrences and layers" => "manual/SpeciesDistributionToolkit/gbif.jl.md",
            "Pseudo-absences" => "manual/SpeciesDistributionToolkit/pseudoabsences.md",
        ],
        "Appendix: datasets" => _dataset_catalogue,
    ],
)

deploydocs(;
    repo = "github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    devbranch = "main",
    push_preview = true,
)
