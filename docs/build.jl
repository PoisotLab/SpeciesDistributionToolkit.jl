# Select the files that we are rendering - if no argument is given, we do the "how-to" folder
folder = isempty(ARGS) ? "howto" : ARGS[1]
fpath = joinpath(@__DIR__, "src", folder)
folder_content = readdir(fpath; join = true)

# Walk the sub-folders as well
for dir in filter(isdir, folder_content)
    append!(folder_content, readdir(dir; join = true))
end

# We only want to .jl files
files_to_build = filter(endswith(".jl"), folder_content)

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

# Render the files
for docfile in files_to_build
    if ~isfile(replace(docfile, r".jl$" => ".md"))
        Literate.markdown(
            docfile, dirname(docfile);
            flavor = Literate.DocumenterFlavor(),
            config = Dict("credit" => false, "execute" => true),
            preprocess = pre!,
            postprocess = post!,
        )
    end
end