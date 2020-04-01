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
numboc = SimpleSDMResponse(zeros(Int64, (20, 20)))
@info convert(Matrix, numboc)
for oc in o
    @info oc
    @info numboc[oc]
    numboc[oc] += 1
    @info numboc[oc]
    @test numboc[oc] >= 1
end

end
