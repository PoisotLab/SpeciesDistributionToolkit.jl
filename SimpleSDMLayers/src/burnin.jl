"""
    burnin!(L::SDMLayer{T}, v::Vector{T})

Replaces the values of `L` by the values in the vector `v`.
"""
function burnin!(L::SDMLayer{T}, v::Vector{T}) where {T}
    @assert length(v) == count(L)
    L.grid[L.indices] .= v
    return L
end

"""
    burnin(L::SDMLayer, v::Vector{T}) where {T}

Writes the value of `v` in a layer similar to `L`, and returns it. It is ASSUMED
(but essentially impossible to check) that the values of `v` are presented in
the correct order. This uses `burnin!` internally.
"""
function burnin(L::SDMLayer, v::Vector{T}) where {T}
    X = similar(L, T)
    burnin!(X, v)
    return X
end