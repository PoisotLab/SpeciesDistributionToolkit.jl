using SimpleSDMDatasets
using Test

global anyerrors = false

tests = [
    "Type basics                 " => "type_construction.jl",
    "WorldClim2 provider         " => "worldclim_v2.jl",
    "EarthEnv provider           " => "earthenv.jl",
    "CHELSA1 provider            " => "chelsa_v1.jl",
    "CHELSA2 provider            " => "chelsa_v2.jl",
    "CHELSA2 provider   (future) " => "chelsa_future_v2.jl",
]

for test in tests
    try
        include(test.second)
        println("\033[1m\033[32m✓\033[0m\t$(test.first)")
    catch e
        global anyerrors = true
        println("\033[1m\033[31m×\033[0m\t$(test.first)")
        println("\033[1m\033[38m→\033[0m\ttest/$(test.second)")
        showerror(stdout, e, backtrace())
        println()
        break
    end
end

if anyerrors
    throw("Tests failed")
end
