using Documenter
using SpeciesDistributionToolkit
using InteractiveUtils
using Markdown
using Dates
using Literate

# Prepare the report card
# include(joinpath(@__DIR__, "report.jl"))

# Compile the vignettes
_list_of_vignettes = filter(f -> endswith(f, ".jl"), readdir("src/vignettes"; join = true))
for vignette in _list_of_vignettes
    Literate.markdown(vignette, "src/vignettes")
end
_compiled_vignettes = filter(f -> endswith(f, ".md"), readdir("src/vignettes"; join = true))

# Prepare a series of pages for the vignettes
_vignettes_pages = Dict{String, String}()
for vignette in _compiled_vignettes
    title = replace(last(splitpath(vignette)), ".md" => "")
    path = joinpath(splitpath(vignette)[2:end])
    _vignettes_pages[titlecase(replace(title, "_" => " "))] = path
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
