"""
    get_valid_coordinates(observations::R, layer::T) where {R <: AbstractOccurrenceCollection, T <: SDMLayer}

Get the coordinates for a list of observations, filtering the ones that do not
correspond to valid layer positions. Valid layer positions are defined as
falling within a valued pixel from the layer.
"""
function get_valid_coordinates(
    observations::R,
    layer::T,
) where {R <: AbstractOccurrenceCollection, T <: SDMLayer}
    xy = place(observations)
    filter!(c -> !ismissing(c), xy) # Only the non-missing observations
    filter!(c -> !isnothing(layer[c...]), xy) # Only the observations in the layer
    return hcat(collect.(unique(xy))...)
end
