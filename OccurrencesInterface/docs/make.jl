using Documenter
using OccurrencesInterface
using Literate
using CairoMakie

# Render the tutorials and how-to using Literate
for vignette in ["demo.jl"]
    fpath = joinpath(@__DIR__, "src")
    Literate.markdown(
        joinpath(fpath, vignette), fpath;
        flavor=Literate.DocumenterFlavor(),
        config=Dict("credit" => false, "execute" => true),
    )
end

makedocs(
    sitename="OccurrencesInterface",
    format=Documenter.HTML(size_threshold_ignore=["demo.md"]),
    modules=[OccurrencesInterface],
    pages=[
        "index.md",
    ],
)

deploydocs(; repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    dirname="OccurrencesInterface",
    tag_prefix="OccurrencesInterface-",
    devbranch="main",
    push_preview=true,
)
