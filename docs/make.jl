# Make sure we work from the version in the repo
sdt_path = dirname(dirname(Base.current_project()))
push!(LOAD_PATH, sdt_path)
using SpeciesDistributionToolkit

# These packages are required to build the documentation website
using Documenter
using DocumenterCitations
using DocumenterVitepress

# These packages are used to generate the cards (for datasets) and pages (for the manual)
using Literate
using Markdown
using InteractiveUtils
using Dates
using PrettyTables

# Steps required before the build
include(joinpath("steps", "bibliography.jl")) # References for the doc
include(joinpath("steps", "changelogs.jl")) # CHANGELOG files on the website
include(joinpath("steps", "datasets.jl")) # Prepare the datasets vignettes
include(joinpath("steps", "polygons.jl")) # Prepare the polygons vignettes

# Generate a report card for each known dataset
include("dataset_report.jl")
include("polygon_report.jl")

# Additional functions to process the text when handled by Literate
include("processing.jl")

# Render the tutorials and how-to using Literate
for folder in ["howto", "tutorials"]
    fpath = joinpath(@__DIR__, "src", folder)
    files_to_build = filter(endswith(".jl"), readdir(fpath; join = true))
    for docfile in files_to_build
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
    plugins = [bib],
)

deploydocs(;
    repo = "github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    devbranch = "main",
    push_preview = true,
)
