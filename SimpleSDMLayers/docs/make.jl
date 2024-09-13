using Documenter
using Statistics
using SimpleSDMLayers

makedocs(;
    sitename = "SimpleSDMLayers",
    format = Documenter.HTML(),
    warnonly = true,
    modules = [SimpleSDMLayers],
    pages = [
        "index.md",
        "types.md",
        "operations.md",
    ],
)

deploydocs(; repo = "github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    dirname = "SimpleSDMLayers",
    tag_prefix = "SimpleSDMLayers-",
    devbranch = "main",
    push_preview = true,
)