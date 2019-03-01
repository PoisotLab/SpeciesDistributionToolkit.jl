using GBIF
using Test

global anyerrors = false

tests = Dict{String,String}(
  "single occurrence functions" => "occurrence.jl",
  "multiple occurrences" => "occurrences.jl",
#  "query cleaning" => "querycleaning.jl",
  "paging" => "paging.jl",
  "iteration" => "iteration.jl",
  "methods" => "methods.jl",
  "filtering" => "filter.jl",
  "species retrieval" => "taxon.jl"
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
