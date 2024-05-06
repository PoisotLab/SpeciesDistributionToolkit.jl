using Documenter
using SimpleSDMLayers

makedocs(;
    sitename = "SimpleSDMLayers",
    format = Documenter.HTML(),
    modules = [SimpleSDMLayers],
    pages = [
        "SimpleSDMLayers.jl" => "index.md",
        "Layer data representation" => "types.md",
        "Basic information on layers" => "basics.md",
        "Operations on layers" => "operations.md",
    ],
)

deploydocs(; repo = "github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    dirname = "SimpleSDMLayers",
    tag_prefix = "SimpleSDMLayers",
    devbranch = "main",
    push_preview = true,
)