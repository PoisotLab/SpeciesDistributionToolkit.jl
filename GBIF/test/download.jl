module GBIFDownloadTest
using Test
using GBIF

# This dataset is all georeferenced records of Negarnaviricota as of
# 2025-04-20 that have a CC0 license
occ = GBIF.download("0007229-250415084134356")
@test length(occ.records) == 265

# Cleanup
rm("0007229-250415084134356.zip")
rm("0007229-250415084134356.csv")

# This is the same dataset but accessed through its DOI
occ2 = GBIF.download("10.15468/dl.kbmyap")
@test length(occ.records) == 265

# Cleanup
rm("0007229-250415084134356.zip")
rm("0007229-250415084134356.csv")


end
