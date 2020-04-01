module SSLTestGBIF
using SimpleSDMLayers
using GBIF
using Test

temperature = worldclim(1)

kingfisher = GBIF.taxon("Megaceryle alcyon", strict=true)

o = GBIF.occurrences(kingfisher)
filter!(GBIF.have_ok_coordinates, o)

# Extract from a single record
for oc in o
    @test typeof(temperature[oc]) <: Number
end

# Modify a value
numboc = SimpleSDMResponse(zeros(Int64, (20, 20)))
@info convert(Matrix, numboc)
for oc in o
    numboc[oc] += 1
end
@test sum(numboc) > 1
@test mean(numboc) > 0.0
@info convert(Matrix, numboc)

end
