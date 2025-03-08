# Make sure we work from the version in the repo
sdt_path = dirname(dirname(Base.current_project()))
push!(LOAD_PATH, sdt_path)
using SpeciesDistributionToolkit

# Load the rest of the build environment
using Documenter
using DocumenterVitepress
using GeoJSON
using Literate
using Markdown
using InteractiveUtils
using Dates
using PrettyTables

# Generate a report card for each known dataset
include("dataset_report.jl")

# Additional functions to process the text when handled by Literate
include("processing.jl")

# Changelogs
include("changelogs.jl")

# Render the tutorials and how-to using Literate
for folder in ["howto", "tutorials"]
    fpath = joinpath(@__DIR__, "src", folder)
    for docfile in filter(endswith(".jl"), readdir(fpath; join = true))
        if ~isfile(replace(docfile, r".jl$" => ".md"))
            Literate.markdown(
                docfile, fpath;
                flavor = Literate.DocumenterFlavor(),
                config = Dict("credit" => false, "execute" => true),
                preprocess = pre!,
                postprocess = post!,
            )
        end
    end
end

makedocs(;
    sitename = "Species Distribution Toolkit",
    format = MarkdownVitepress(;
        repo = "github.com/PoisotLab/SpeciesDistributionToolkit.jl",
    ),
    warnonly = true,
)

deploydocs(;
    repo = "github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    devbranch = "main",
    push_preview = true,
)
