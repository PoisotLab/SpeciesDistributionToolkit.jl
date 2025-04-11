"""
    provides
"""
SimpleSDMDatasets.provides(::Type{P}, ::Type{D}) where {P<:PolygonProvider,D<:PolygonDataset} = false

"""
    levels
"""
levels(::PolygonData) = nothing 

"""
    resolutions
"""
SimpleSDMDatasets.resolutions(::PolygonData) = nothing 

"""
    destination
"""
destination(::PolygonData{P, D}; kwargs...) where {P <: PolygonProvider, D <: PolygonDataset} =
    joinpath(_POLYGON_PATH, string(P), string(D))


"""
    postprocess
"""
postprocess(::PolygonData{P,D}, result::R) where {P,D,R} = error("`postprocess` has not been implemented for provider $P and dataset $D. An overload of the `postprocess` method is necessary for the interface.")

"""
    _extra_keychecks

Used for checking combinations of keyword arguments. 

For example, for some [`Country`](@ref) providers, different `country`s have different available `level`s, and these provider implement this method to check if the requested (country, level) pair is provided. 
"""
_extra_keychecks(::PolygonData{P,D}; kw...) where {P,D} = nothing 