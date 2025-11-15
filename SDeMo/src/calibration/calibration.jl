abstract type AbstractCalibration end

_keywordsfor(::Type{<:AbstractCalibration}) = Symbol[]

function _kwsplitter(C::Type{<:AbstractCalibration}, args::Base.Pairs)
    cal_kw = []
    mod_kw = []
    for arg in args
        if arg.first in _keywordsfor(C)
            push!(cal_kw, arg)
        else
            push!(mod_kw, arg)
        end
    end
    return cal_kw, mod_kw
end

function calibrate(cal::Type{C}, sdm::T; kwargs...) where {C <: AbstractCalibration, T <: AbstractSDM}
    calibrator_kw, model_kw = _kwsplitter(cal, kwargs)
    x, y = _calibrationdata(sdm; model_kw...)
    return calibrate(cal, x, y; calibrator_kw...)
end

function _calibrationdata(sdm::T; samples=:, kwargs...) where {T <: AbstractSDM}
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


@testitem "We can do Isotonic calibration (some values, keywords)" begin
    X, y = SDeMo.__demodata()
    model = SDM(PCATransform, NaiveBayes, X, y)
    train!(model)
    @assert IsotonicCalibration <: AbstractCalibration
    C = calibrate(IsotonicCalibration, model, bins=15, samples=bootstrap(model)[1][1])
    @test typeof(C) <: IsotonicCalibration
end

@testitem "We can do Isotonic calibration (bootstrapped values, keywords)" begin
    X, y = SDeMo.__demodata()
    model = SDM(PCATransform, NaiveBayes, X, y)
    train!(model)
    @assert IsotonicCalibration <: AbstractCalibration
    folds = first.(bootstrap(model))
    C = [calibrate(IsotonicCalibration, model; samples=s, bins=35) for s in folds]
end