"""
    get_valid_coordinates(observations::GBIFRecords, layer::T) where {T <: SDMLayer}

Get the coordinates for a list of observations, filtering the ones that do not
correspond to valid layer positions. Valid layer positions are defined as
falling within a valued pixel from the layer.
"""
function get_valid_coordinates(observations::GBIFRecords, layer::T) where {T <: SDMLayer}
    xy = [(obs.longitude, obs.latitude) for obs in observations]
    filter!(c -> !isnothing(layer[c...]), xy)
    return hcat(collect.(unique(xy))...)
end
