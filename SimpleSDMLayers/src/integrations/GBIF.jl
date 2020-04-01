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
   ismissing(occurrence.latitude) && return NaN
   ismissing(occurrence.longitude) && return NaN
   return p[occurrence.longitude, occurrence.latitude]
end

"""
    Base.setindex!(p::T, v, occurrence::GBIFRecord) where {T <: SimpleSDMResponse}

Changes the values of the cell including the point at the requested latitude and
longitude.
"""
function Base.setindex!(p::SimpleSDMResponse{T}, v::T, occurrence::GBIF.GBIFRecord) where {T}
   ismissing(occurrence.latitude) && return nothing
   ismissing(occurrence.longitude) && return nothing
   setindex!(p, v, occurrence.longitude, occurrence.latitude)
end
