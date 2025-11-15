abstract type AbstractCalibration end

function calibrate(sdm::T; kwargs...) where {T <: AbstractSDM}
    return calibrate(PlattCalibration, sdm; maxiter=1_000, tol=1e-5, kwargs...)
end

"""
    correct(cal::AbstractCalibration)

Returns a function that gives a probability given a calibration result.
"""
function correct(cal::AbstractCalibration)
    return (y) -> correct(cal, y)
end

"""
    correct(cal::Vector{<:AbstractCalibration})

Returns a function that gives the average of probabilities from a vector of
calibration results. This is used when bootstrapping or cross-validating
probabilities using a pre-trained model.
"""
function correct(cal::Vector{<:AbstractCalibration})
    return (y) -> mean([correct(c, y) for c in cal])
end