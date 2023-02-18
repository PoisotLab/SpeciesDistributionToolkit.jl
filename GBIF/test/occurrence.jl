module TestOccurrence

using GBIF
using Test

# This occurrence exists 
k = 3986160931
o = occurrence(k)
@test typeof(o) == GBIFRecord
@test o.key == k

# This piece of shit occurrence has been deleted, so this needs some wrapping
k = 1258202889
o = occurrence(k)
@test typeof(o) == GBIFRecord
@test o.key == k

# Piece of shit uncorrectly formatted occurence
k = 1039645472
o = occurrence(k)
@test typeof(o) == GBIFRecord

end
