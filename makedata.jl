using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit

# Set the seed to the same value everytime
import Random
Random.seed!("SDeMo")

using DelimitedFiles

# Get the data folder
_data_folder = tempdir()
if !ispath(_data_folder)
    mkpath(_data_folder)
end

# Training data at global scale for the nested SDM
global_doi = "10.15468/dl.aefk4v"
records = GBIF.download(global_doi, path=_data_folder);

# Clip for Corsica
region = getpolygon(PolygonData(ESRI, Places))["Country" => "France"]["Place name" => "Corse"]

# CHELSA2 data
provider = RasterData(CHELSA2, BioClim)
L = SDMLayer{Float32}[SDMLayer(provider; layer=l, SDT.boundingbox(region)...) for l in layers(provider)]
mask!(L, region)

# Generate training pseudo-absences
presencelayer = mask(first(L), records)
background = pseudoabsencemask(DistanceToEvent, presencelayer)
nocloser = nodata(background, d -> !(3 <= d <= 40))
absencelayer = backgroundpoints(nocloser .^ 0.5, 1sum(presencelayer))

# Model
sdm = SDM(RawData, NaiveBayes, L, presencelayer, absencelayer)
folds = kfold(sdm)
train!(sdm)
cv = crossvalidate(sdm, folds)
@info mcc(cv.validation)

# Generate the dataframes we need to get the demo data for SDeMo
N = vcat(northings(presencelayer), northings(absencelayer))
E = vcat(eastings(presencelayer), eastings(absencelayer))

function layercoordinates(L::SDMLayer{Bool})
    ks = keys(nodata(L, false))
    N = northings(L)
    E = eastings(L)
    return [(E[k[2]], N[k[1]]) for k in ks]
end

xy = vcat(layercoordinates(presencelayer), layercoordinates(absencelayer))
prsc = keys(nodata(presencelayer, false))
absc = keys(nodata(absencelayer, false))
coord = vcat(prsc, absc)

# Write the data
demo_data_path = joinpath(pwd(), "SDeMo", "data")
writedlm(joinpath(demo_data_path, "coordinates.csv"), xy)
writedlm(joinpath(demo_data_path, "features.csv"), features(sdm))
writedlm(joinpath(demo_data_path, "labels.csv"), labels(sdm))
