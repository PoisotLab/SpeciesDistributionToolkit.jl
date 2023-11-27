function Base.Array(layers::Vector{T}) where {T <: SimpleSDMLayers.SimpleSDMLayer}
    @assert SimpleSDMLayers._layers_are_compatible(layers)
    k = reduce(intersect, [findall(!isnothing, grid(layer)) for layer in layers])
    R = SimpleSDMLayers._inner_type(first(layers))
    X = Matrix{R}(undef, length(layers), length(k))
    for i in eachindex(k)
        for j in eachindex(layers)
            X[j,i] = layers[j][k[i]]
        end
    end
    return X
end