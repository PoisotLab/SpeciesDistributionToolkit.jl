module SSLTestExtrema
using SimpleSDMLayers
using Test

# Test 1

S = SimpleSDMPredictor([1 2 3; 4 5 6; 7 nothing 9], 0.0, 1.0, 0.0, 1.0)

@test extrema(S) == (1, 9)
@info S[findmax(S)...]
@info findmin(S)

# Test 2

bbox = (left=-83.0, bottom=46.4, right=-55.2, top=63.7);
temp = convert(Float32, SimpleSDMPredictor(WorldClim, BioClim, 7; bbox...))

tempmin, tempmax = extrema(temp)
@test tempmin ≈ 1.0f0
@test tempmax ≈ 51.8575f0

@info findmax(temp)
# > ([-55.25, 52.083333333333336] => 28.3f0, [-55.25, 52.083333333333336])

@info findmin(temp)
# > ([-82.91666666666667, 46.416666666666664] => 40.6895f0, [-82.91666666666667, 46.416666666666664])

end