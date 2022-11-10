using Documenter
using SpeciesDistributionsToolkit
using InteractiveUtils
using Markdown
using Dates

# Prepare the report card
# include(joinpath(@__DIR__, "report.jl"))

makedocs(;
    sitename = "Species Distributions Toolkit",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", nothing) == true,
    ),
    pages = [
        "Index" => "index.md",
    ],
)

deploydocs(; repo = "github.com/PoisotLab/SpeciesDistributionsToolkit.jl.git")
