using Documenter
using Fauxcurrences

makedocs(
    sitename="Fauxcurrences",
    format=Documenter.HTML(
        repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl",
        devbranch="main",
        devurl="dev",
    ),
    modules=[Fauxcurrences],
    pages=[
        "Fauxcurrences.jl" => "index.md",
    ],
)

deploydocs(; repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    dirname="Fauxcurrences",
    tag_prefix="Fauxcurrences-",
    devbranch="main",
    push_preview=true,
)
