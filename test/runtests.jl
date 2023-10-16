using TestItemRunner

function test_is_valid(ti)
    if :skipci in ti.tags
        return false
    end
    for component in ["GBIF", "Phylopic", "Fauxcurrences", "SimpleSDMLayers", "SimpleSDMDatasets"]
        if contains(ti.filename, "$(component)/src")
            return false
        end
    end
    return true
end

@run_package_tests filter=test_is_valid verbose=true