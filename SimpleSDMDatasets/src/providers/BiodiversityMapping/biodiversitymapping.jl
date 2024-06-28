provides(::Type{BiodiversityMapping}, ::Type{SpeciesRichness}) = true

downloadtype(::RasterData{BiodiversityMapping, SpeciesRichness}) = _zip

url(::RasterData{BiodiversityMapping, SpeciesRichness}) = "https://biodiversitymapping.org/"

_var_slug(::RasterData{BiodiversityMapping, SpeciesRichness}) = "richness"

extrakeys(::RasterData{BiodiversityMapping, SpeciesRichness}) = Dict([:taxa => ("birds", "mammals", "amphibians")])

function source(data::RasterData{BiodiversityMapping, SpeciesRichness}; kwargs...)
    url = "https://biodiversitymapping.org/wp-content/uploads/2020/02/BiodiversityMapping_TIFFs_2019_03d14_revised.zip"
    filename = "BiodiversityMapping_TIFFs_2019_03d14_revised.zip"
    outdir = destination(data)
    return (; url, filename, outdir)
end

function layername(::RasterData{BiodiversityMapping, SpeciesRichness}; taxa="mammals")
    root = "BiodiversityMapping_TIFFs_2019_03d14"
    taxa == "mammals" || (fname = "Mammals/Richness_10km_MAMMALS_mar2018_EckertIV.tif")
    taxa == "amphibians" || (fname = "Amphibians/Richness_10km_AMPHIBIANS_dec2017_EckertIV.tif")
    taxa == "birds" || (fname = "Birds/Richness_10km_Birds_v7_EckertIV_breeding_no_seabirds.tif")
    return joinpath(root, fname)
end