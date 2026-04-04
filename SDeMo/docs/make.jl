using Documenter
using SDeMo

# This package has a bunch of generated functions...

makedocs(;
    sitename = "SDeMo",
    format = Documenter.HTML(;
        size_threshold_warn = 250 * 2^10, # raise warning at 250
        size_threshold = 500 * 2^10, # break at 500
    ),
    modules = [SDeMo],
    pages = [
        "index.md",
    ],
)

deploydocs(; repo = "github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    dirname = "SDeMo",
    tag_prefix = "SDeMo-",
    devbranch = "main",
    push_preview = true,
)
