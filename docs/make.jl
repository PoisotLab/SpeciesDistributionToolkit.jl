# Make sure we work from the version in the repo
sdt_path = dirname(dirname(Base.current_project()))
push!(LOAD_PATH, sdt_path)
using SpeciesDistributionToolkit

# Load the rest of the build environment
using Documenter
using DocumenterVitepress
using DocumenterCitations
using Literate
using Markdown
using InteractiveUtils
using Dates
using PrettyTables
import Downloads

# Download the bibliography from paperpile public URL
const bibfile = joinpath(@__DIR__, "src", "references.bib")
const paperpile_url = "https://paperpile.com/eb/nimbzsGosN"
if isfile(bibfile)
    rm(bibfile)
end
Downloads.download(paperpile_url, bibfile)

# Cleanup the bibliography file to make DocumenterCitations happy despite their
# refusal to acknowledge modern field names. The people will partu like it's
# 1971 and they will like it.
lines = readlines(bibfile)
open(bibfile, "w") do bfile
    for line in lines
        if contains(line, "journaltitle")
            println(bfile, replace(line, "journaltitle" => "journal"))
        elseif contains(line, "date")
            yrmatch = match(r"{(\d{4})", line)
            if !isnothing(yrmatch)
                println(bfile, "year = {$(yrmatch[1])},")
            end
            println(bfile, line)
        else
            println(bfile, line)
        end
    end
end
# Look how they massacred my boy

bib = CitationBibliography(
    bibfile;
    style = :authoryear,
)

# Generate a report card for each known dataset
include("dataset_report.jl")
include("polygon_report.jl")

# Changelogs
include("changelogs.jl")

makedocs(;
    sitename = "Species Distribution Toolkit",
    format = MarkdownVitepress(;
        repo = "github.com/PoisotLab/SpeciesDistributionToolkit.jl",
    ),
    warnonly = true,
    plugins = [bib],
)

deploydocs(;
    repo = "github.com/PoisotLab/SpeciesDistributionToolkit.jl.git",
    devbranch = "main",
    push_preview = true,
)
