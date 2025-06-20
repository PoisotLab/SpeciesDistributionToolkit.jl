# This file will create the changelogs for each packages. Specifically, it will
# go through all the folders for component packages, then format the lines so
# that any issue number is turned into a link to the repo. This happens
# automatically during building, and requires no user input.

chg_path = joinpath(dirname(dirname(@__FILE__)), "docs", "src", "reference", "changelog")

if !ispath(chg_path)
    mkpath(chg_path)
end

function _issue_number_updater!(path; repo = "PoisotLab/SpeciesDistributionToolkit.jl")
    lines = readlines(path)
    search_pattern = r"\[#(\d+)\]"
    replace_pattern = SubstitutionString("[#\\1](https://github.com/$(repo)/issues/\\1)")
    open(path, "w") do file
        for line in lines
            if contains(line, search_pattern)
                line = replace(line, search_pattern => replace_pattern)
            end
            println(file, line)
        end
    end
    return path
end

# SDT
cp(
    joinpath(dirname(dirname(@__FILE__)), "CHANGELOG.md"),
    joinpath(chg_path, "SpeciesDistributionToolkit.md");
    force = true,
)

for pkg in [
    "GBIF",
    "SDeMo",
    "OccurrencesInterface",
    "SimpleSDMLayers",
    "SimpleSDMDatasets",
    "SimpleSDMPolygons",
    "Fauxcurrences",
    "Phylopic",
    "PseudoAbsences",  
]
    cp(
        joinpath(dirname(dirname(@__FILE__)), pkg, "CHANGELOG.md"),
        joinpath(chg_path, "$(pkg).md");
        force = true,
    )
    _issue_number_updater!(joinpath(chg_path, "$(pkg).md"))
end