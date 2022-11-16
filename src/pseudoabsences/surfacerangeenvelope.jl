function Base.rand(::Type{SurfaceRangeEnvelope}, presences::T) where {T <: SimpleSDMLayer}
    @assert SimpleSDMLayers._inner_type(presences) <: Bool
    n_occ = sum(presences)
    iszero(n_occ) && throw(ArgumentError("The presences layer is empty"))
    _msk = mask(presences, presences)
    acceptable_cells = setdiff(keys(presences), keys(_msk))
    rlat = extrema([p[2] for p in keys(_msk)])
    rlon = extrema([p[1] for p in keys(_msk)])
    filter!(p -> rlat[1] <= p[2] <= rlat[2], acceptable_cells)
    filter!(p -> rlon[1] <= p[1] <= rlon[2], acceptable_cells)
    if length(acceptable_cells) < n_occ
        @warn "There are fewer acceptable pseudo-absences than occurrences"
    end
    pa_places = sample(acceptable_cells, min(length(acceptable_cells), n_occ), replace=false)
    pa = similar(presences, Bool)
    pa[pa_places] = fill(true, length(pa_places))
    return pa
end