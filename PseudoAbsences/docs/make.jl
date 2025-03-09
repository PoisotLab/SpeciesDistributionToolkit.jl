using Documenter
using PseudoAbsences

makedocs(
    sitename="PseudoAbsences",
    format=Documenter.HTML(),
    modules=[Fauxcurrences],
    pages=[
        "index.md"
    ],
)

deploydocs(; repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    dirname="PseudoAbsences",
    tag_prefix="PseudoAbsences-",
    devbranch="main",
    push_preview=true,
)
