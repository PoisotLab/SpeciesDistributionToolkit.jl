Base.@kwdef struct IsotonicCalibration <: AbstractCalibration
    calibrator::Function
end

_keywordsfor(::Type{IsotonicCalibration}) = [:bins]

"""
    calibrate(::Type{IsotonicCalibration}, sdm::T; bins=25, kwargs...)

Returns the isotonic calibration result for a given SDM
"""
function calibrate(::Type{IsotonicCalibration}, x::Vector{<:Real}, y::Vector{Bool}; bins=25)
    X, Y = SDeMo._calibration_bins(x, y, bins)
    return PAVA(X, Y)
end

function PAVA(x, y, w=ones(length(y)))
    
    # Sort by x values
    perm = sortperm(x)
    x_sorted = x[perm]
    y_sorted = y[perm]
    w_sorted = w[perm]

    n = length(y_sorted)
    r = copy(y_sorted)
    ws = copy(w_sorted)
    xs = copy(x_sorted)
    target = [[i] for i in 1:n]
    i = 2
    counter = 0

    while i <= n
        if r[i] < r[i-1]  # Find adjacent violators
            # Pool the violators
            r[i] = (ws[i] * r[i] + ws[i-1] * r[i-1]) / (ws[i] + ws[i-1])
            ws[i] += ws[i-1]
            xs[i] = xs[i-1]  # Keep the left x value for the pooled block
            target[i] = vcat(target[i-1], target[i])

            # Remove elements at index i-1
            deleteat!(r, i - 1)
            deleteat!(ws, i - 1)
            deleteat!(xs, i - 1)
            deleteat!(target, i - 1)

            n -= 1
            # Move back one step if possible
            if i > 2
                i -= 1
            end
        else
            i += 1
            counter += 1
        end
    end

    # Map back to original indices
    sol = zeros(eltype(y), length(y))
    for (i, block) in enumerate(target)
        sol[perm[block]] .= r[i]
    end

    # Create step function representation for arbitrary point evaluation
    breakpoints = Float64[]
    values = Float64[]

    for (i, block) in enumerate(target)
        push!(breakpoints, x_sorted[minimum(block)])
        push!(values, r[i])
    end
    # Add upper bound
    if length(target) > 0
        push!(breakpoints, x_sorted[maximum(target[end])])
    end

    # Create interpolation function
    function evaluate(x_new)
        if x_new <= breakpoints[1]
            return values[1]
        elseif x_new > breakpoints[end]
            return values[end]
        else
            # Find the appropriate block
            idx = searchsortedlast(breakpoints[1:end-1], x_new)
            return values[idx]
        end
    end

    return IsotonicCalibration(evaluate)
end

function correct(is::IsotonicCalibration, y)
    return is.calibrator(y)
end
