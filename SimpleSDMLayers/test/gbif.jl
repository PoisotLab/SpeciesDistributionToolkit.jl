module SSLTestGBIF
using SimpleSDMLayers
using GBIF
using Test

temperature = worldclim(1)
o = GBIF.occurrences()
filter!(GBIF.have_ok_coordinates, o)

# Extract from a single record
for oc in o
    @test typeof(temperature[oc]) <: Number
    @info temperature[oc]
end

# Modify a value
numboc = SimpleSDMResponse(zeros(Int64, (20, 20)), -180., 180., -90., 90.)
for oc in o
    numboc[oc] += 1
    @test numboc[oc] > 0
    @info numboc[oc]
end

end
