using Documenter
using SpeciesDistributionToolkit
using InteractiveUtils
using Markdown
using Dates
using Literate

# Prepare the report card
# include(joinpath(@__DIR__, "report.jl"))

const _vignettes_dir = "docs/src/vignettes"

# Compile the vignettes
_list_of_vignettes = filter(f -> endswith(f, ".jl"), readdir(_vignettes_dir; join = true))
_vignettes_pages = Vector{Pair{String, String}}[]
for vignette in _list_of_vignettes
    Literate.markdown(vignette, joinpath(pwd(), _vignettes_dir))
    compiled_vignette = replace(vignette, ".jl" => ".md")
    title = replace(last(splitpath(compiled_vignette)), ".md" => "")
    path = joinpath(splitpath(compiled_vignette)[3:end])
    push!(_vignettes_pages, titlecase(replace(title, "_" => " ")) => path)
end

makedocs(;
    sitename = "Species Distribution Toolkit",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", nothing) == true,
    ),
    pages = [
        "Index" => "index.md",
        "Vignettes" => _vignettes_pages,
    ],
)

deploydocs(; repo = "github.com/PoisotLab/SpeciesDistributionToolkit.jl.git")
