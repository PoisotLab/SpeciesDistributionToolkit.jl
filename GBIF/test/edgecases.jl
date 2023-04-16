module GBIFEdgeCasesTest
using Test
using GBIF

# When there is a single argument used for a query, sometimes the second position gets
# converted to not text
queryset = ["hasCoordinate" => true]
@test length(occurrences(queryset...)) > 0

queryset = ["hasCoordinate" => true]
@test length(occurrences(taxon("Alces alces"), queryset...)) > 0

end
