abstract type AbstractCalibration end

function calibrate(sdm::T; kwargs...) where {T <: AbstractSDM}
    return calibrate(PlattCalibration, sdm; maxiter=1_000, tol=1e-5, kwargs...)
end

function correct(cal::AbstractCalibration)
    return (y) -> correct(cal, y)
end