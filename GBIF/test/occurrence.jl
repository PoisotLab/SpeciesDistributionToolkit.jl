module TestOccurrence

using GBIF
using Test

# This occurrence exists 
k = 3986160931
o = occurrence(k)
@test typeof(o) == GBIFRecord
@test o.key == k

end
