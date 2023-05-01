using Documenter
using SpeciesDistributionToolkit
using InteractiveUtils
using Markdown
using Dates
using Literate

# Generate a report card for each known dataset
include("dataset_report.jl")

# Compile the stories for the top-level package
_stories_categories = [
    "basic" => "Basic",
    "intermediate" => "Intermediate",
    "advanced" => "Advanced",
]
_stories_pages = Pair{String, Vector{Pair{String, String}}}[]
for _category in _stories_categories
    folder, title = _category
    stories = filter(
        endswith(".jl"),
        readdir(joinpath("docs", "src", "userstories", folder); join = true),
    )
    this_category = Pair{String, String}[]
    for story in stories
        Literate.markdown(story, joinpath("docs", "src", "userstories", folder))
        compiled_story = replace(story, ".jl" => ".md")
        push!(
            this_category,
            last(split(readlines(story)[1], "# # ")) =>
                joinpath(splitpath(compiled_story)[3:end]),
        )
    end
    push!(_stories_pages, title => this_category)
end

makedocs(;
    sitename = "Species Distribution Toolkit",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", nothing) == true,
    ),
    pages = [
        "Home" => "index.md",
        "User stories" => _stories_pages,
        "SpeciesDistributionToolkit.jl" => [
            "Home" => "manual/SpeciesDistributionToolkit/index.md",
            "Occurrences and layers" => "manual/SpeciesDistributionToolkit/gbif.jl.md",
            "Pseudo-absences" => "manual/SpeciesDistributionToolkit/pseudoabsences.md",
        ],
        "SimpleSDMLayers.jl" => [
            "Home" => "manual/SimpleSDMLayers/index.md",
            "Layer data representation" => "manual/SimpleSDMLayers/types.md",
            "Basic information on layers" => "manual/SimpleSDMLayers/basics.md",
            "Operations on layers" => "manual/SimpleSDMLayers/operations.md",
        ],
        "GBIF.jl" => [
            "Home" => "manual/GBIF/index.md",
            "GBIF data representation" => "manual/GBIF/types.md",
            "GBIF data retrieval" => "manual/GBIF/data.md",
            "Enumerated query parameters" => "manual/GBIF/enums.md",
        ],
        "Phylopic.jl" => [
            "Home" => "manual/Phylopic/index.md",
        ],
        "SimpleSDMDatasets.jl" => [
            "Home" => "manual/SimpleSDMDatasets/index.md",
            "List of datasets" => _dataset_catalogue,
            "Dataset representation" => "manual/SimpleSDMDatasets/dev/types.md",
            "Data retrieval interface" => "manual/SimpleSDMDatasets/dev/interface.md",
            "Internals" => "manual/SimpleSDMDatasets/dev/internals.md",
        ],
    ],
)

deploydocs(;
    repo = "github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    devbranch = "main",
    push_preview = true,
)
