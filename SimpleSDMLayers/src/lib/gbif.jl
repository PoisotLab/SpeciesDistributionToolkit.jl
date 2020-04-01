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
   isnothing(getfield(occurrence, :latitude, nothing)) && return NaN
   isnothing(getfield(occurrence, :longitude, nothing)) && return NaN
   return p[occurrence.latitude, occurrence.longitude]
end

function Base.getindex(p::T, occurrence::GBIFRecord) where {T <: SimpleSDMLayer}
   @info "Lol"
   isnothing(getfield(occurrence, :latitude, nothing)) && return NaN
   isnothing(getfield(occurrence, :longitude, nothing)) && return NaN
   return p[occurrence.latitude, occurrence.longitude]
end

"""
    Base.setindex!(p::T, v, occurrence::GBIFRecord) where {T <: SimpleSDMResponse}

Changes the values of the cell including the point at the requested latitude and
longitude.
"""
function Base.setindex!(p::T, v, occurrence::GBIF.GBIFRecord) where {T <: SimpleSDMResponse}
   isnothing(getfield(occurrence, :latitude, nothing)) && return nothing
   isnothing(getfield(occurrence, :longitude, nothing)) && return nothing
   setindex!(p, v, occurrence.latitude, occurence.longitude)
end
