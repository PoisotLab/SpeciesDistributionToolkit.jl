using Documenter
using SimpleSDMLayers

makedocs(;
    sitename = "SimpleSDMLayers",
    format = Documenter.HTML(),
    modules = [SimpleSDMLayers],
    pages = [
        "SimpleSDMLayers.jl" => "index.md",
        "Easy manipulation of layers" => "manual/SimpleSDMLayers/index.md",
        "Layer data representation" => "manual/SimpleSDMLayers/types.md",
        "Basic information on layers" => "manual/SimpleSDMLayers/basics.md",
        "Operations on layers" => "manual/SimpleSDMLayers/operations.md",
    ],
)

deploydocs(; repo = "github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    dirname = "SimpleSDMLayers",
    tag_prefix = "SimpleSDMLayers",
    devbranch = "main",
    push_preview = true,
)