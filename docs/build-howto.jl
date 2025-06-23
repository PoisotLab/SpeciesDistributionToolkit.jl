# Make sure we work from the version in the repo
sdt_path = dirname(dirname(Base.current_project()))
push!(LOAD_PATH, sdt_path)
using SpeciesDistributionToolkit

# Load the rest of the build environment
using Literate
using Markdown
using InteractiveUtils
using Dates
using PrettyTables
import Downloads

# Additional functions to process the text when handled by Literate
include("processing.jl")

# Render the tutorials and how-to using Literate
folder = "howto"
fpath = joinpath(@__DIR__, "src", folder)
files_to_build = filter(endswith(".jl"), readdir(fpath; join = true))
for docfile in files_to_build
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