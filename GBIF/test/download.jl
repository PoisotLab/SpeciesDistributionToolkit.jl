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

# This dataset had issues with delimited
doi = "10.15468/dl.t7jzv8"
occ3 = GBIF.download(doi)
@test length(occ3) > 0
rm("0015079-250811113504898.csv")

# Download with a path
temp_cache_file = join(rand('a':'z', 10), "")
GBIF.download(doi; path = temp_cache_file)
csv_file = joinpath(temp_cache_file, "0015079-250811113504898.csv")
zip_file = joinpath(temp_cache_file, "0015079-250811113504898.zip")
@test isfile(csv_file)
@test isfile(zip_file)
rm(csv_file)
rm(zip_file)
rm(temp_cache_file)

end
