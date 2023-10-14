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

# Compile the vignettes for the top-level package
_vignettes_categories = [
    "layers" => "Working with layers",
    "occurrences" => "Working with occurrences",
    "integration" => "Integration examples",
]
_vignettes_pages = Pair{String, Vector{Pair{String, String}}}[]
for _category in _vignettes_categories
    folder, title = _category
    vignettes = filter(
        endswith(".jl"),
        readdir(joinpath("docs", "src", "vignettes", folder); join = true),
    )
    this_category = Pair{String, String}[]
    for vignette in vignettes
        Literate.markdown(vignette, joinpath("docs", "src", "vignettes", folder))
        compiled_vignette = replace(vignette, ".jl" => ".md")
        push!(
            this_category,
            last(split(readlines(vignette)[1], "# # ")) =>
                joinpath(splitpath(compiled_vignette)[3:end]),
        )
    end
    push!(_vignettes_pages, title => this_category)
end

makedocs(;
    sitename = "Species Distribution Toolkit",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", nothing) == true,
    ),
    warnonly = true,
    pages = [
        "Index" => "index.md",
        "Vignettes" => _vignettes_pages,
        "List of datasets" => _dataset_catalogue,
        "Component packages" => [
            "SpeciesDistributionToolkit.jl" => [
                "Work with species occurrence data" => "manual/SpeciesDistributionToolkit/index.md",
                "Occurrences and layers" => "manual/SpeciesDistributionToolkit/gbif.jl.md",
                "Pseudo-absences" => "manual/SpeciesDistributionToolkit/pseudoabsences.md",
            ],
            "Phylopic.jl" => [
                "Integration with Phylopic" => "manual/Phylopic/index.md",
            ],
            "SimpleSDMLayers.jl" => [
                "Easy manipulation of layers" => "manual/SimpleSDMLayers/index.md",
                "Layer data representation" => "manual/SimpleSDMLayers/types.md",
                "Basic information on layers" => "manual/SimpleSDMLayers/basics.md",
                "Operations on layers" => "manual/SimpleSDMLayers/operations.md",
            ],
            "GBIF.jl" => [
                "Interface to GBIF data" => "manual/GBIF/index.md",
                "GBIF data representation" => "manual/GBIF/types.md",
                "GBIF data retrieval" => "manual/GBIF/data.md",
                "Enumerated query parameters" => "manual/GBIF/enums.md",
            ],
            "SimpleSDMDatasets.jl" => [
                "Interface to raster data" => "manual/SimpleSDMDatasets/index.md",
                "Dataset representation" => "manual/SimpleSDMDatasets/dev/types.md",
                "Data retrieval interface" => "manual/SimpleSDMDatasets/dev/interface.md",
                "Internals" => "manual/SimpleSDMDatasets/dev/internals.md",
            ],
        ],
    ],
)

deploydocs(;
    repo = "github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    devbranch = "main",
    push_preview = true,
)
