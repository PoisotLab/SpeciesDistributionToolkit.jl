# Make sure we work from the version in the repo
sdt_path = dirname(dirname(Base.current_project()))
push!(LOAD_PATH, sdt_path)
using SpeciesDistributionToolkit

# Load the rest of the build environment
using Documenter
using DocumenterVitepress
using Literate
using Markdown
using InteractiveUtils
using Dates

# Generate a report card for each known dataset
include("dataset_report.jl")

function replace_current_figure(content)
    fig_hash = string(hash(content)) * "-" * string(hash(rand(100)))

    matcher = r"""^# fig-(?<title>[\w-]+)$
    (?<code>(?>^[^#].*$\n){1,})^current_figure\(\) #hide$"""m

    replacement_template = """
    # ![](HASH-\\g<title>.png)


    # ::: details Code for the figure

    \\g<code>save("HASH-\\g<title>.png", current_figure()); #hide

    # :::
    """
    replacer = SubstitutionString(replace(replacement_template, "HASH" => fig_hash))
    content = replace(content, matcher => replacer)
    return content
end

# Render the tutorials and how-to using Literate
for folder in ["howto", "tutorials"]
    fpath = joinpath(@__DIR__, "src", folder)
    for docfile in filter(endswith(".jl"), readdir(fpath; join = true))
        if ~isfile(replace(docfile, r".jl$" => ".md"))
            @info docfile
            Literate.markdown(
                docfile, fpath;
                flavor = Literate.DocumenterFlavor(),
                config = Dict("credit" => false, "execute" => true),
                preprocess = replace_current_figure,
            )
        end
    end
end

makedocs(;
    sitename = "Species Distribution Toolkit",
    format = MarkdownVitepress(;
        repo = "github.com/PoisotLab/SpeciesDistributionToolkit.jl",
    ),
    warnonly = true,
    pages = [
        "Manual" => "manual.md",
        "Tutorials" => [
            "tutorials/arithmetic.md",
            "tutorials/statistics.md",
            "tutorials/consensus.md",
            "tutorials/layers_and_occurrences.md",
            "tutorials/bioclim.md",
            "tutorials/polygons.md",
            "tutorials/pseudoabsences.md",
            "tutorials/fauxcurrences.md",
            "tutorials/futureclimate.md",
            "tutorials/zonal.md",
            "tutorials/sdemo.md",
        ],
        "How-to..." => [
            "howto/get-gbif-data.md",
            "howto/list-provided-layers.md",
            "howto/read-part-layer.md",
            "howto/mask-layer.md",
            "howto/split-layer.md",
            "howto/interpolate.md",
            "howto/makie.md",
        ],
        "Documentation" => [
            "manual/contributing.md",
            "manual/index.md",
            "manual/gbif.jl.md",
            "manual/pseudoabsences.md",
            "manual/polygons.md",
            "manual/gadm.md",
            "manual/utilities.md"
        ],
    ],
)

deploydocs(;
    repo = "github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    devbranch = "main",
    push_preview = true,
)
