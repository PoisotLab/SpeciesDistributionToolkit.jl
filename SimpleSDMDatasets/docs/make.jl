using Documenter
using SimpleSDMDatasets

makedocs(;
    sitename="SimpleSDMDatasets",
    format=Documenter.HTML(
        repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl",
        devbranch="main",
        devurl="dev",
    ),
    modules=[SimpleSDMDatasets],
    pages=[
        "Index" => "index.md",
        "Interface" => "interface.md",
        "Types" => "types.md",
        "Internals" => "internals.md",
    ],
)

deploydocs(; repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    dirname="SimpleSDMDatasets",
    tag_prefix="SimpleSDMDatasets-",
    devbranch="main",
    push_preview=true,
)
