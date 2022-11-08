using Documenter
using SimpleSDMDatasets
using InteractiveUtils
using Markdown
using Dates

# Prepare the report card
include(joinpath(@__DIR__, "report.jl"))

makedocs(;
    sitename = "SimpleSDMDatasets.jl",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", nothing) == true,
    ),
    pages = [
        "Index" => "index.md",
        "Guide for users" => [
            "Retrieving data" => "usr/getdata.md",
            "List of providers" => [
                "CHELSA (version 1)" => "usr/CHELSA1.md",
                "CHELSA (version 2)" => "usr/CHELSA2.md",
                "WorldClim (version 2)" => "usr/WorldClim2.md",
                "EarthEnv" => "usr/EarthEnv.md",
            ],
        ],
        "Guide for contributors" => [
            "How it fits together" => "dev/internals.md",
            "Interface" => "dev/interface.md",
            "Type system" => "dev/types.md",
        ],
    ],
)

deploydocs(; repo = "github.com/PoisotLab/SimpleSDMDatasets.jl.git")