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
include(joinpath("steps", "manual.jl")) # Compile the manual (this is the big one!)

# This MAKES the docs - this is required to succeed before we can deploy the docs
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
