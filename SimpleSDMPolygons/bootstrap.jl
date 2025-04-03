import Pkg

components = []

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
    # This is yucky but it's helpful when dealing with calling this file from the doc folder in the Documentation action
    pkg_path = ispath("./$(package)") ? "./$(package)" : "../$(package)"
    Pkg.develop(; path = pkg_path)
end
