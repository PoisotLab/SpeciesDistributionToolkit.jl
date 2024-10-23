using Documenter
using Fauxcurrences

makedocs(
    sitename="Fauxcurrences",
    format=Documenter.HTML(),
    modules=[Fauxcurrences],
    pages=[
        "index.md"
    ],
)

deploydocs(; repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    dirname="Fauxcurrences",
    tag_prefix="Fauxcurrences-",
    devbranch="main",
    push_preview=true,
)
