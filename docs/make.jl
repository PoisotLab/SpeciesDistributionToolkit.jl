using Documenter
using SpeciesDistributionToolkit
using InteractiveUtils
using Markdown
using Dates
using Literate

# Generate a report card for each known dataset
include("dataset_report.jl")
_dataset_catalogue = [
    string(P) => joinpath("SimpleSDMDatasets", "catalogue", "$(P).md")
    for P in subtypes(RasterProvider)
]

# Compile the vignettes for the top-level package
const _vignettes_dir = "docs/src/vignettes"
_list_of_vignettes = filter(f -> endswith(f, ".jl"), readdir(_vignettes_dir; join = true))
_vignettes_pages = Pair{String, String}[]
for vignette in _list_of_vignettes
    Literate.markdown(vignette, joinpath(pwd(), _vignettes_dir))
    compiled_vignette = replace(vignette, ".jl" => ".md")
    title = last(split(readlines(vignette)[1], "# # "))
    path = joinpath(splitpath(compiled_vignette)[3:end])
    push!(_vignettes_pages, title => path)
end

makedocs(;
    sitename = "Species Distribution Toolkit",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", nothing) == true,
    ),
    pages = [
        "Index" => "index.md",
        "Vignettes" => _vignettes_pages,
        "GBIF.jl" => [
            "GBIF.jl" => "GBIF/index.md",
            "GBIF data representation" => "GBIF/types.md",
            "GBIF data retrieval" => "GBIF/data.md",
        ],
        "SimpleSDMDatasets.jl" => [
            "SimpleSDMDatasets.jl" => "SimpleSDMDatasets/index.md",
            "Dataset catalogue" => _dataset_catalogue,
            "For developers" => [
                "Data representation" => "SimpleSDMDatasets/dev/types.md",
                "Data retrieval interface" => "SimpleSDMDatasets/dev/interface.md",
                "Internals" => "SimpleSDMDatasets/dev/internals.md",
            ],
        ],
    ],
)

deploydocs(;
    repo = "github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    push_preview = true,
)
