function Base.rand(::Type{WithinRadius}, presences::T; distance::Number=1.0) where {T <: SimpleSDMLayer}
    @assert SimpleSDMLayers._inner_type(presences) <: Bool
    n_occ = sum(presences)
    iszero(n_occ) && throw(ArgumentError("The presences layer is empty"))
    _msk = mask(presences, presences)
    _radius_msk = similar(presences, Bool)
    for k in keys(_msk)
        _msk_keys = keys(mask(Circle(k, distance), presences))
        _radius_msk[_msk_keys] = fill(true, length(_msk_keys))
    end
    _radius_msk = mask(_radius_msk, _radius_msk)
    acceptable_cells = setdiff(keys(_radius_msk), keys(_msk))
    if length(acceptable_cells) < n_occ
        @warn "There are fewer acceptable pseudo-absences than occurrences"
    end
    pa_places = sample(acceptable_cells, min(length(acceptable_cells), n_occ), replace=false)
    pa = similar(presences, Bool)
    pa[pa_places] = fill(true, length(pa_places))
    return pa
end