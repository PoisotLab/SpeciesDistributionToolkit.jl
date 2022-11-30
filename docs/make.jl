# push!(LOAD_PATH, pwd())

using Documenter
using SpeciesDistributionToolkit
using InteractiveUtils
using Markdown
using Dates
using Literate

# Generate a report card for each known dataset
include("docs/dataset_report.jl")

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
    pages = [
        "Index" => "index.md",
        "Vignettes" => _vignettes_pages,
        "List of datasets" => _dataset_catalogue,
        "GBIF.jl" => [
            "GBIF.jl" => "GBIF/index.md",
            "GBIF data representation" => "GBIF/types.md",
            "GBIF data retrieval" => "GBIF/data.md",
        ],
        "SimpleSDMDatasets.jl" => [
            "SimpleSDMDatasets.jl" => "SimpleSDMDatasets/index.md",
            "Data representation" => "SimpleSDMDatasets/dev/types.md",
            "Data retrieval interface" => "SimpleSDMDatasets/dev/interface.md",
            "Internals" => "SimpleSDMDatasets/dev/internals.md",
        ],
    ],
)

deploydocs(;
    repo = "github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    push_preview = true,
)
