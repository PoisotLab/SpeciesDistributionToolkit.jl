using SimpleSDMLayers
using Test

global anyerrors = false

tests = [
   "construction" => "construction.jl",
   "basics" => "basics.jl",
   "matching" => "matching.jl",
   "overloads" => "overloads.jl",
   "ascii" => "ascii.jl",
   "iteration" => "iteration.jl",
   "rescale" => "rescale.jl",
   "mosaic" => "mosaic.jl",
   "generated" => "generated.jl",
   "import" => "dataread.jl",
   "worldclim" => "worldclim.jl",
   "earthenv" => "earthenv.jl",
   "chelsa" => "chelsa.jl",
   "subsetting" => "subsetting.jl",
   "coarsen" => "coarsen.jl",
   "plotting" => "plots.jl",
   "GBIF" => "gbif.jl",
   "DataFrames" => "dataframes.jl"
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
