using Documenter
using SDeMo
using Literate
using CairoMakie

function replace_current_figure(content)
    fig_hash = string(hash(content)) * "-" * string(hash(rand(100)))

    matcher = r"""^# fig-(?<title>[\w-]+)$
    (?<code>(?>^[^#].*$\n){1,})^current_figure\(\) #hide$"""m

    replacement_template = """
    # ![](HASH-\\g<title>.png)


    # !!! details "Code for the figure""
        \\g<code>save("HASH-\\g<title>.png", current_figure()); #hide

    """
    replacer = SubstitutionString(replace(replacement_template, "HASH" => fig_hash))
    content = replace(content, matcher => replacer)
    return content
end

# Render the tutorials and how-to using Literate
for vignette in ["demo.jl"]
    fpath = joinpath(@__DIR__, "src")
    Literate.markdown(
        joinpath(fpath, vignette), fpath;
        flavor=Literate.DocumenterFlavor(),
        config=Dict("credit" => false, "execute" => true),
        preprocess=replace_current_figure,
    )
end

makedocs(
    sitename="SDeMo",
    format=Documenter.HTML(),
    modules=[SDeMo],
    pages=[
        "index.md",
        "models.md",
        "crossvalidation.md",
        "features.md",
        "explanations.md",
        "ensembles.md",
        "saving.md",
        "demo.md"
    ],
)

deploydocs(; repo="github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    dirname="SDeMo",
    tag_prefix="SDeMo-",
    devbranch="main",
    push_preview=true,
)
