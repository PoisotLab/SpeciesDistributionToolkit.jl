# Make sure we work from the version in the repo
sdt_path = dirname(dirname(Base.current_project()))
push!(LOAD_PATH, sdt_path)
using SpeciesDistributionToolkit

# Load the rest of the build environment
using Documenter
using Markdown
using Literate
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
            "Index" => "tutorials/index.md",
            "Arithmetic on layers" => "tutorials/arithmetic.md",
            "Landcover consensus" => "tutorials/consensus.md",
        ],
        "How-to..." => [
            "Index" => "howtos/index.md",
            "... get GBIF data?" => "howtos/gbifdata.md",
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
