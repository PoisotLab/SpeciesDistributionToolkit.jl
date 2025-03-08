chg_path = joinpath(dirname(dirname(@__FILE__)), "docs", "src", "reference", "changelog")

if !ispath(chg_path)
    mkpath(chg_path)
end

# SDT
cp(
    joinpath(dirname(dirname(@__FILE__)), "CHANGELOG.md"),
    joinpath(chg_path, "SpeciesDistributionToolkit.md");
    force = true
)

for pkg in ["GBIF", "SDeMo", "OccurrencesInterface", "SimpleSDMLayers", "SimpleSDMDatasets", "Fauxcurrences", "Phylopic"]
cp(
    joinpath(dirname(dirname(@__FILE__)), pkg, "CHANGELOG.md"),
    joinpath(chg_path, "$(pkg).md");
    force = true
)
end