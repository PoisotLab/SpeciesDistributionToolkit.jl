using GBIF
using Base.Test

anyerrors = false

tests = Dict{String,String}(
  "single occurrence functions" => "occurrence.jl",
  "multiple occurrences" => "occurrences.jl",
  "query cleaning" => "querycleaning.jl",
  "paging" => "paging.jl",
  "methods" => "methods.jl",
  "quality control" => "qualitycontrol.jl",
  "species retrieval" => "species.jl",
  "export to DataFrame" => "dataframe.jl"
)

for (name,test) in tests
  try
    include(test)
    println("\033[1m\033[32m✓\033[0m\t$(name)")
  catch e
    anyerrors = true
    println("\033[1m\033[31m×\033[0m\t$(name)")
    println("\033[1m\033[38m→\033[0m\ttest/$(test)")
    showerror(STDOUT, e, backtrace())
    println()
  end
end

if anyerrors
  throw("Tests failed")
end
