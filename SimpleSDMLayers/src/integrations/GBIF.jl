# WARNING this file is only loaded if GBIF.jl is also active
# This all happens thanks to the Requires.jl package

import Base: getindex
import Base: setindex!

"""
    Base.getindex(p::T, occurrence::GBIF.GBIFRecord) where {T <: SimpleSDMLayer}

Extracts the value of a layer at a given position for a `GBIFRecord`. If the
`GBIFRecord` has no latitude or longitude, this will return `NaN`.
"""
function Base.getindex(p::T, occurrence::GBIF.GBIFRecord) where {T <: SimpleSDMLayer}
   ismissing(getfield(occurrence, :latitude, missing)) && return NaN
   ismissing(getfield(occurrence, :longitude, missing)) && return NaN
   return p[occurrence.latitude, occurrence.longitude]
end

"""
    Base.setindex!(p::T, v, occurrence::GBIFRecord) where {T <: SimpleSDMResponse}

Changes the values of the cell including the point at the requested latitude and
longitude.
"""
function Base.setindex!(p::T, v, occurrence::GBIF.GBIFRecord) where {T <: SimpleSDMResponse}
   ismissing(getfield(occurrence, :latitude, missing)) && return nothing
   ismissing(getfield(occurrence, :longitude, missing)) && return nothing
   setindex!(p, v, occurrence.latitude, occurence.longitude)
end
