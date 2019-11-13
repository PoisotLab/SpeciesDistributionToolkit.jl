using SimpleSDMLayers
using Test

global anyerrors = false

tests = Dict{String,String}(
                            "construction" => "construction.jl",
                            "basics" => "basics.jl",
                            "overloads" => "overloads.jl",
                            "worldclim" => "worldclim.jl",
                            "plotting" => "plots.jl"
                           )

for (name,test) in tests
   try
      include(test)
      println("\033[1m\033[32m✓\033[0m\t$(name)")
   catch e
      global anyerrors = true
      println("\033[1m\033[31m×\033[0m\t$(name)")
      println("\033[1m\033[38m→\033[0m\ttest/$(test)")
      showerror(stdout, e, backtrace())
      println()
      break
   end
end

if anyerrors
   throw("Tests failed")
end
