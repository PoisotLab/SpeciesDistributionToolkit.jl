import Pkg

components = ["SimpleSDMLayers", "GBIF"]

# Cleanup local install and develop
for package in components
    @info "Removing $(package)"
    try
        Pkg.rm(package)
    catch e
        continue
    end
end
for package in components
    @info "Dev'ing $(package)"
    Pkg.develop(; path = "./$(package)")
end
