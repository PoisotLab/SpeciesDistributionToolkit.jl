using GBIF
using Base.Test

# Basics
k = 1425221362
o = occurrence(k)
@test typeof(o) == Occurrence
@test o.key == k

# Occurrences
qpars = Dict("scientificName" => "Mus musculus", "year" => 1999, "hasCoordinate" => true)
set = occurrences(qpars)
@test typeof(set) == Occurrences
@test length(set) == 20
@test set.cleaned == false

# Next
next!(set)
@test length(set) == 40
@test set.cleaned == false

# Qualitycontrol
qualitycontrol!(set)
@test set.cleaned == true

# We can't continue requests on a filtered set
@test_warn "A filtered list" next!(set)
@test_warn "A filtered list" complete!(set)

# But we can restart it
restart!(set)
@test set.cleaned == false
