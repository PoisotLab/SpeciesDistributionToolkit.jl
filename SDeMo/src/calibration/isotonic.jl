Base.@kwdef struct IsotonicCalibration <: AbstractCalibration
    A::Real = 0.0
    B::Real = 0.0
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
    i = 2  # Julia uses 1-based indexing, so start at 2
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

    return (solution=sol, weights=ws, blocks=target,
        breakpoints=breakpoints[1:end-1], values=values,
        x_breaks=breakpoints, evaluate=evaluate)
end

function mkbins(x, y, bins)
    nqs = bins
    #qs = quantile(x, LinRange(0.0, 1.0, nqs))
    qs = LinRange(extrema(x)..., nqs)

    X = zeros(nqs - 1)
    Y = zeros(nqs - 1)

    for i in 1:(nqs-1)
        in_chunk = findall(qs[i] .<= x .< qs[i+1])
        X[i] = mean(x[in_chunk])
        Y[i] = mean(y[in_chunk])
    end
    return X, Y
end

function pava_calibration(prd, trt; range=:, bins=25)

    X, Y = mkbins(prd[range], trt[range], bins)

    return PAVA(X, Y).evaluate
end
