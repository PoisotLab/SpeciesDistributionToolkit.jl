"""
    SimpleSDMPredictor(::Type{EarthEnv}, ::Type{HabitatHeterogeneity}, layer::Integer=1; resolution::Int64=25, kwargs...)

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

function SimpleSDMPredictor(::Type{EarthEnv}, ::Type{HabitatHeterogeneity}, layers::AbstractArray; kwargs...)
    @assert eltype(layers) <: Integer
    return [SimpleSDMPredictor(EarthEnv, HabitatHeterogeneity, l; kwargs...) for l in layers]
end
