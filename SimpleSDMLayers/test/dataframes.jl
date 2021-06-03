module SSLTestDataFrames
using SimpleSDMLayers
using DataFrames
using Test

temperature = SimpleSDMPredictor(WorldClim, BioClim, 1)

df = DataFrame(longitude = [30.0, 31.0], latitude = [0.0, 1.0], values = [42.0, 15.0])

@test eltype(temperature[df]) <: Number

temperature_clip = clip(temperature, df)

@test typeof(temperature_clip) == typeof(temperature)

df1 = DataFrame(temperature_clip)
df2 = DataFrame([temperature_clip, temperature_clip])

@test typeof(df1) == DataFrame
@test eltype(df1.values) == Union{Missing, eltype(temperature_clip)}
@test typeof(df2) == DataFrame
@test eltype(df2.x1) == Union{Missing, eltype(temperature_clip)}

@test typeof(SimpleSDMPredictor(df, :values, temperature_clip)) <: SimpleSDMLayer
@test typeof(SimpleSDMPredictor(df, :values, temperature_clip)) <: SimpleSDMPredictor

l1 = SimpleSDMPredictor(df1, :values, temperature_clip)
l2 = SimpleSDMPredictor(df2, :x2, temperature_clip)
for l in (l1, l2)
    @test isequal(l.grid, temperature_clip.grid)
    @test isequal(longitudes(l), longitudes(temperature_clip))
    @test isequal(latitudes(l), latitudes(temperature_clip))
end

mbool = mask(temperature_clip, df, Bool)
@test eltype(mbool) == Bool

mfloat = mask(temperature_clip, df, Float64)
@test eltype(mfloat) == Float64

@test sum(mfloat) >= sum(mbool)
@test sum(mfloat) == nrow(df)

end
