using Documenter
using SpeciesDistributionToolkit
using InteractiveUtils
using Markdown
using Dates
using Literate

# Prepare the report card
# include(joinpath(@__DIR__, "report.jl"))

const _vignettes_dir = "docs/src/vignettes"

# Compile the vignettes for the top-level package
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
            "Index" => "GBIF/index.md",
            "Types" => "GBIF/types.md",
            "Retrieving data" => "GBIF/data.md",
        ],
    ],
)

deploydocs(; repo = "github.com/PoisotLab/SpeciesDistributionToolkit.jl.git")
