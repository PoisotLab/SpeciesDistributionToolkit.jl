module TestOccurrence

using GBIF
using Test

# This occurrence exists 
k = 3986160931
o = occurrence(k)
@test typeof(o) == GBIFRecord
@test o.key == k

# This occurrence has been deleted, so this needs some wrapping
k = 1258202889
@test_throws "cannot be accessed - error code" occurrence(k)

# This occurence is incorrectly formatted for some reason
k = 1039645472
o = occurrence(k)
@test typeof(o) == GBIFRecord

end
