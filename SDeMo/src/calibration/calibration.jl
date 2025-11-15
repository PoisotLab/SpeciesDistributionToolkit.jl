abstract type AbstractCalibration end

function calibrate(cal::C, sdm::T; samples=:, kwargs...) where {C <: AbstractCalibration, T <: AbstractSDM}
    x, y = _calibrationdata(sdm, samples; kwargs...)
    return calibrate(cal, x, y)
end

function calibrate(sdm::T; kwargs...) where {T <: AbstractSDM}
    return calibrate(PlattCalibration, sdm; kwargs...)
end

function _calibrationdata(sdm::T, samples=:, kwargs...) where {T <: AbstractSDM}
    scores = predict(sdm; threshold=false, kwargs...)[samples]
    truth = labels(sdm)[samples]
    return (scores, truth)
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

@testitem "We can do Platt calibration (all values)" begin
    X, y = SDeMo.__demodata()
    model = SDM(PCATransform, NaiveBayes, X, y)
    train!(model)
    C = calibrate(PlattCalibration, model)
    @test typeof(C) <: PlattCalibration
end