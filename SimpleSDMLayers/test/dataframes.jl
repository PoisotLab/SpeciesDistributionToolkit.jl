module SSLTestDataFrames
using SimpleSDMLayers
using DataFrames
using Test

temperature = SimpleSDMPredictor(WorldClim, BioClim, 1)

df = DataFrame(latitude = [0.0, 1.0], longitude = [30.0, 31.0], values = [42.0, 15.0])

@test eltype(temperature[df]) <: Number

temperature_clip = clip(temperature, df)

@test typeof(temperature_clip) == typeof(temperature)

@test typeof(DataFrame(temperature_clip)) == DataFrame
@test eltype(DataFrame(temperature_clip).values) == eltype(temperature_clip.grid)
@test typeof(DataFrame([temperature_clip, temperature_clip])) == DataFrame
@test eltype(DataFrame([temperature_clip, temperature_clip]).x1) == eltype(temperature_clip.grid)

@test typeof(SimpleSDMPredictor(df, :values, temperature_clip)) <: SimpleSDMLayer
@test typeof(SimpleSDMPredictor(df, :values, temperature_clip)) <: SimpleSDMPredictor

mbool = mask(temperature_clip, df, Bool)
@test eltype(mbool) == Bool

mfloat = mask(temperature_clip, df, Float64)
@test eltype(mfloat) == Float64

@test sum(mfloat) >= sum(mbool)
@test sum(mfloat) == nrow(df)

end
