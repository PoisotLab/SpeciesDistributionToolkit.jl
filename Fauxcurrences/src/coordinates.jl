"""
Get the coordinates for a list of observations, filtering the ones that do not
correspond to valid layer positions
"""
function get_valid_coordinates(observations::GBIFRecords, layer::T) where {T <: SimpleSDMLayer}
    xy = [(observations[i].longitude, observations[i].latitude) for i in 1:length(observations)]
    filter!(c -> !isnothing(layer[c...]), xy)
    return hcat(collect.(unique(xy))...)
end
