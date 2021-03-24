"""
    landcover(layers::Vector{T}; full::Bool=false, path::AbstractString="assets") where {T <: Integer}

Download and prepare the EarthEnv consensus landcover data, and returns them as
an array of `SimpleSDMPredictor`s. Layers are called by their number, from 1 to
14. The list of available layers is given in a table below. The raw data come
from https://www.earthenv.org/landcover.

THe `full` keyword indicates whether the *DISCover* information must be
included. Quoting from the reference website:

> Although DISCover is based on older remote sensing imagery (1992-1993), it
> contains some complementary information which is useful for capturing
> sub-pixel land cover heterogeneity (please see the associated article for
> details). Therefore, it is recommended to use the full version of the
> consensus land cover dataset for most applications. However, the reduced
> version may provide an alternative for applications in regions with large land
> cover change in the past two decades.

It is recommended to *keep* the content of the `path` folder, as it will
eliminate the need to download and/or extract the tiff files. For example,
calling `landcover(1:12)` will download and extract everything, and future calls
will be much faster. Please keep in mind that the layers can be quite large, so
keeping the models stored is particularly important.

| Variable | Explanation              | Measure                                                          | Value range                         | Relationship to heterogeneity |
| -------- | ------------------------ | ---------------------------------------------------------------- | ----------------------------------- | ----------------------------- |
| 1        | Coefficient of variation | Normalized dispersion of EVI                                     | >=0                                 | Positive                      |
| 2        | Evenness                 | Evenness of EVI                                                  | >=0; <=1                            | Positive                      |
| 3        | Range                    | Range of EVI                                                     | >=0                                 | Positive                      |
| 4        | Shannon                  | Diversity of EVI                                                 | >=0; <=ln(max # of different EVI)   | Positive                      |
| 5        | Simpson                  | Diversity of EVI                                                 | >=0; <=1-1/(max # of different EVI) | Positive                      |
| 6        | Standard deviation       | Dispersion of EVI                                                | >=0                                 | Positive                      |
| 7        | Contrast                 | Exponentially weighted difference in EVI between adjacent pixels | >=0                                 | Positive                      |
| 8        | Correlation              | Linear dependency of EVI on adjacent pixels                      | >=-1; <=1                           | Nonlinear                     |
| 9        | Dissimilarity            | Difference in EVI between adjacent pixels                        | >=0                                 | Positive                      |
| 10       | Entropy                  | Disorderliness of EVI                                            | >=0                                 | Positive                      |
| 11       | Homogeneity              | Similarity of EVI between adjacent pixels                        | >=0; <=1                            | Negative                      |
| 12       | Maximum                  | Dominance of EVI combinations between adjacent pixels            | >=0; <=1                            | Negative                      |
| 13       | Uniformity               | Orderliness of EVI                                               | >=0; <=1                            | Negative                      |
| 14       | Variance                 | Dispersion of EVI combinations between adjacent pixels           | >=0                                 | Positive                      |

These data are released under a CC-BY-NC license to Tuanmu & Jetz.
"""
function SimpleSDMPredictor(::Type{EarthEnv}, ::Type{HabitatHeterogeneity}, layer::Integer=1; resolution::Int64=25, kwargs...)
    @assert resolution in [1, 5, 25]
    file = _get_raster(EarthEnv, HabitatHeterogeneity, layer, resolution)
    return geotiff(SimpleSDMPredictor, file; kwargs...)
end

function SimpleSDMPredictor(::Type{EarthEnv}, ::Type{HabitatHeterogeneity}, layers::Vector{T}; kwargs...) where {T <: Integer}
    return [SimpleSDMPredictor(EarthEnv, HabitatHeterogeneity, l; kwargs...) for l in layers]
end

function SimpleSDMPredictor(::Type{EarthEnv}, ::Type{HabitatHeterogeneity}, layers::UnitRange{T}; kwargs...) where {T <: Integer}
    return SimpleSDMPredictor(EarthEnv, HabitatHeterogeneity, collect(layers); kwargs...)
end