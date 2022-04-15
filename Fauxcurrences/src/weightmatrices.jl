"""
All matrices have the same weight
"""
function _equal_weight(n)
    M = ones(Float64, n, n)
    for i in 1:(n-1)
        for j in (i+1):n
            M[j, i] = zero(eltype(M))
        end
    end
    return M ./ sum(M)
end

"""
The intra-specific component has relative weight `intra` -- for a value of 1.0,
the model is a purely intra-specific one
"""
function _weighted_components(n, intra)
    @assert 0.0 <= intra <= 1.0
    inter = 1.0 - intra
    M = ones(Float64, n, n)
    for i in 1:(n-1)
        for j in (i+1):n
            M[j, i] = zero(eltype(M))
            M[i, j] = inter / (n * (n - 1) / 2)
        end
    end
    M[diagind(M)] .= intra / n
    return M ./ sum(M)
end

"""
The intra and inter components have the same weight, which means the
inter-specific matrices can have less cumulative weight
"""
_equal_components(n) = _weighted_components(n, 0.5)