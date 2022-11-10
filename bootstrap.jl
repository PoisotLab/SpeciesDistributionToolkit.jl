import Pkg

components = ["SimpleSDMDatasets", "SimpleSDMLayers", "GBIF", "Fauxcurrences"]

# Cleanup local install and develop
for package in components
    @info "Removing $(package)"
    Pkg.rm(package)
    @info "Dev'ing $(package)"
    Pkg.develop(; path = "./$(package)")
end
