bdmap = [MammalRichness, AmphibianRichness, BirdRichness]
BiodivMap = Union{bdmap...}

provides(::Type{BiodiversityMapping}, ::Type{T}) where {T <: BiodivMap} = true

url(::Type{BiodiversityMapping}) = "https://biodiversitymapping.org/"

blurb(::Type{BiodiversityMapping}) = md"""
Summary of the richness of different taxonomic groups at a 10x10 km resolution.

::: details Citation

Jenkins, C.N., Pimm, S.L., and Joppa, L.N. (2013). Global patterns of
terrestrial vertebrate diversity and conservation. Proc. Natl. Acad. Sci. U. S.
A. 110, E2602-10.

:::
"""

downloadtype(::RasterData{BiodiversityMapping, T}) where {T <: BiodivMap} = _zip

destination(::RasterData{BiodiversityMapping, T}; kwargs...) where {T <: BiodivMap} = joinpath(SimpleSDMDatasets._LAYER_PATH, string(BiodiversityMapping))

layers(::RasterData{BiodiversityMapping, MammalRichness}) = ["Mammals", "Carnivora", "Cetartiodactyla", "Chiroptera", "Eulipotyphla", "Marsupialia", "Primates", "Rodentia"]
layers(::RasterData{BiodiversityMapping, AmphibianRichness}) = ["Amphibians", "Anura", "Caudata", "Gymnophiona"]
layers(::RasterData{BiodiversityMapping, BirdRichness}) = ["Birds", "Passeriformes", "Psittaciformes", "Trochilidae"]

function layerdescriptions(::RasterData{BiodiversityMapping, T}) where {T <: BiodivMap}
    layername = layers(RasterData(BiodiversityMapping, T))
    return Dict(zip(layername, layername))
end

function source(data::RasterData{BiodiversityMapping, T}; kwargs...) where {T <: BiodivMap}
    url = "https://biodiversitymapping.org/wp-content/uploads/2020/02/BiodiversityMapping_TIFFs_2019_03d14_revised.zip"
    filename = "BiodiversityMapping_TIFFs_2019_03d14_revised.zip"
    outdir = destination(data)
    return (; url, filename, outdir)
end

function layername(::RasterData{BiodiversityMapping, BirdRichness}; layer="Birds")
    layer = layer == "Birds" ? "breeding_no_seabirds" : layer
    root = "BiodiversityMapping_TIFFs_2019_03d14/Birds"
    fname = "Richness_10km_Birds_v7_EckertIV_$(layer).tif"
    return joinpath(root, fname)
end

function layername(::RasterData{BiodiversityMapping, MammalRichness}; layer="Mammals")
    layer = layer == "Mammals" ? "" : "_$(layer)"
    root = "BiodiversityMapping_TIFFs_2019_03d14/Mammals"
    fname = "Richness_10km_MAMMALS_mar2018_EckertIV$(layer).tif"
    return joinpath(root, fname)
end

function layername(::RasterData{BiodiversityMapping, AmphibianRichness}; layer="Amphibians")
    layer = layer == "Amphibians" ? "" : "_$(layer)"
    root = "BiodiversityMapping_TIFFs_2019_03d14/Amphibians"
    fname = "Richness_10km_AMPHIBIANS_dec2017_EckertIV$(layer).tif"
    return joinpath(root, fname)
end