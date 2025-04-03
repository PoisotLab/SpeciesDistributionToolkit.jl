"""
    keychecker
"""
function keychecker(data::P; kwargs...) where {P<:PolygonData}
    # Check for levels
    if :level in keys(kwargs)
        isnothing(levels(data)) && error("The $(P) dataset does not allow for month as a keyword argument")
        values(kwargs).level ∉ levels(data) && error("The level $(values(kwargs).level) is not supported by the $(P) dataset")
    end

    # Check for resolution
    if :resolution in keys(kwargs)
        isnothing(resolutions(data)) && error("The $(P) dataset does not support multiple resolutions")
        
        values(kwargs).resolution ∉ keys(resolutions(data)) && error("The resolution $(values(kwargs).resolution) is not supported by the $(P) dataset")
    end

    # Apply method data specific keychecks 
    # This is used for checking the validity combinations of keywords 
    _extra_keychecks(data; kwargs...)
end