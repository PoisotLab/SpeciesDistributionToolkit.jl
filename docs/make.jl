# Make sure we work from the version in the repo
sdt_path = dirname(dirname(Base.current_project()))
push!(LOAD_PATH, sdt_path)
using SpeciesDistributionToolkit

# Load the rest of the build environment
using Documenter
using DocumenterVitepress
using GeoJSON
using Literate
using Markdown
using InteractiveUtils
using Dates
using PrettyTables

# Generate a report card for each known dataset
include("dataset_report.jl")

# Additional functions to process the text when handled by Literate
include("processing.jl")

# Changelogs
include("changelogs.jl")

# Render the tutorials and how-to using Literate
for folder in ["howto", "tutorials"]
    fpath = joinpath(@__DIR__, "src", folder)
    files_to_build = filter(endswith(".jl"), readdir(fpath; join = true))
    # This uses all threads to gain time when building
    chunk_size = max(1, length(files_to_build) ÷ (3 * Threads.nthreads()))
    data_chunks = Base.Iterators.partition(files_to_build, chunk_size)
    tasks = map(data_chunks) do docfiles
        Threads.@spawn begin
            for docfile in docfiles
                if ~isfile(replace(docfile, r".jl$" => ".md"))
                    Literate.markdown(
                        docfile, fpath;
                        flavor = Literate.DocumenterFlavor(),
                        config = Dict("credit" => false, "execute" => true),
                        preprocess = pre!,
                        postprocess = post!,
                    )
                end
            end
        end
    end
    # Fetch the tasks
    fetch.(tasks)
end

makedocs(;
    sitename = "Species Distribution Toolkit",
    format = MarkdownVitepress(;
        repo = "github.com/PoisotLab/SpeciesDistributionToolkit.jl",
    ),
    warnonly = true,
)

deploydocs(;
    repo = "github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    devbranch = "main",
    push_preview = true,
)
