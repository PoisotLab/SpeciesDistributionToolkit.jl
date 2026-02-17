# # Preparing data for prediction

using SpeciesDistributionToolkit
using CairoMakie

#

spatial_extent = (left = 5.0, bottom = 57.5, right = 10.0, top = 62.7)

#

rangifer = taxon("Rangifer tarandus tarandus"; strict = false)
query = [
    "occurrenceStatus" => "PRESENT",
    "hasCoordinate" => true,
    "decimalLatitude" => (spatial_extent.bottom, spatial_extent.top),
    "decimalLongitude" => (spatial_extent.left, spatial_extent.right),
    "limit" => 300,
]
presences = occurrences(rangifer, query...)
for i in 1:3
    occurrences!(presences)
end

#

dataprovider = RasterData(CHELSA1, BioClim)

varnames = layerdescriptions(dataprovider)

#

layers = [
    convert(
        SimpleSDMResponse,
        1.0SimpleSDMPredictor(dataprovider; spatial_extent..., layer = lname),
    ) for
    lname in keys(varnames)
]

#

originallayers = deepcopy(layers)

# 

presenceonly = mask(layers[1], presences, Bool)
absenceonly = SpeciesDistributionToolkit.sample(
    pseudoabsencemask(SurfaceRangeEnvelope, presenceonly),
    250,
)
replace!(presenceonly, false => nothing)
replace!(absenceonly, false => nothing)
for cell in absenceonly
    presenceonly[cell.longitude, cell.latitude] = false
end

for i in eachindex(layers)
    keys_to_void = setdiff(keys(layers[i]), keys(presenceonly))
    for k in keys_to_void
        layers[i][k] = nothing
    end
end

layers

#

refs = Ref.([layers..., presenceonly])

datastack = SimpleSDMStack([values(varnames)..., "Presence"], refs)

predictionstack = SimpleSDMStack([values(varnames)...], Ref.(originallayers))

# 


using DataFrames
DataFrame(datastack)

#

using MLJ

# 

y, X = unpack(select(DataFrame(datastack), Not([:longitude, :latitude])), ==(:Presence));
y = coerce(y, Continuous)

#

Standardizer = @load Standardizer pkg = MLJModels add = true verbosity = 0
LM = @load LinearRegressor pkg = MLJLinearModels add = true verbosity = 0
model = Standardizer() |> LM()

#

mach = machine(model, X, y) |> fit!

#

perf_measures = [mcc, f1score, accuracy, balanced_accuracy]
evaluate!(
    mach;
    resampling = CV(; nfolds = 3, shuffle = true, rng = Xoshiro(234)),
    measure = perf_measures,
)

#

value = predict(mach, select(DataFrame(predictionstack), Not([:longitude, :latitude])));

#

prediction = select(DataFrame(predictionstack), [:longitude, :latitude]);
prediction.value = value;

#

output = Tables.materializer(SimpleSDMResponse)(prediction)

# 

heatmap(sprinkle(output)...; colormap = :viridis)
scatter!(longitudes(presences), latitudes(presences))
current_figure()
