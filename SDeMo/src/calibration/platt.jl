Base.@kwdef struct PlattCalibration <: AbstractCalibration
    A::Real = 0.0
    B::Real = 0.0
end

"""
    calibration(sdm::T; kwargs...) where {T <: AbstractSDM}

Returns a function for model calibration, using Platt scaling, optimized with
the Newton method. The returned function can be applied to a model output.
"""
function calibrate(::Type{PlattCalibration}, x, y; maxiter=1_000, tol=1e-5) where {T <: AbstractSDM}
    n₀ = sum(y)
    n₁ = length(y) - sum(y)

    # Newton method parameters
    minstep = 1e-10
    σ = 1e-12

    # Updated targets with a correction for prevalence
    t₁ = (n₁ + 1.0) / (n₁ + 2.0)
    t₀ = 1 / (n₀ + 2.0)
    t = fill(t₀, length(C))
    t[findall(y)] .= t₁

    # Initial values for A and B
    A = 0.0
    B = log((n₀ + 1.0) / (n₁ + 1.0))

    # Initial update of f
    fval = 0.0
    for i in eachindex(t)
        fApB = d[i] * A + B
        if fApB >= 0.0
            fval += t[i] * fApB + log(1 + exp(-fApB))
        else
            fval += (t[i] - 1) * fApB + log(1 + exp(fApB))
        end
    end

    # Iteration
    for _ in Base.OneTo(maxiter)
        # Gradient, Hessian
        h11 = h22 = σ
        h21 = g1 = g2 = 0.0
        for i in eachindex(y)
            fApB = d[i] * A + B
            if fApB >= 0
                p = exp(-fApB) / (1.0 + exp(-fApB))
                q = 1.0 / (1.0 + exp(-fApB))
            else
                p = 1.0 / (1.0 + exp(fApB))
                q = exp(fApB) / (1.0 + exp(fApB))
            end
            d2 = p * q
            h11 += x[i] * x[i] * d2
            h22 += d2
            h21 += x[i] * d2
            d1 = t[i] - p
            g1 += x[i] * d1
            g2 += d1
        end

        # Early stopping if the gradient is very small
        if (abs(g1) < tol) && (abs(g2) < tol)
            break
        end

        # Newton directions

        det = h11 * h22 - h21 * h21
        dA = -(h22 * g1 - h21 * g2) / det
        dB = -(-h21 * g1 + h11 * g2) / det
        gd = g1 * dA + g2 * dB
        stepsize = 1
        while (stepsize >= minstep)
            newA = A + stepsize * dA
            newB = B + stepsize * dB
            newf = 0.0
            for i in eachindex(C)
                fApB = d[i] * newA + newB
                if (fApB >= 0)
                    newf += t[i] * fApB + log(1 + exp(-fApB))
                else
                    newf += (t[i] - 1) * fApB + log(1 + exp(fApB))
                end
                if (newf < fval + 0.0001 * stepsize * gd)
                    A = newA
                    B = newB
                    fval = newf
                    break
                else
                    stepsize /= 2.0
                end
                if (stepsize < minstep)
                    break
                end
            end
        end
    end

    return PlattCalibration(A, B)
end

function correct(pl::PlattCalibration, y)
    ŷ = 1.0 ./ (1.0 .+ exp.(pl.A .* y .+ pl.B))
    return ŷ
end
