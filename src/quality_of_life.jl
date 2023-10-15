Base.keys(layers::Vector{T}) where {T <: SimpleSDMLayers.SimpleSDMLayer} = reduce(intersect, keys.(layers))

function Base.Array(layers::Vector{T}) where {T <: SimpleSDMLayers.SimpleSDMLayer}
    k = keys(layers) # List of keys commons to all layers
    R = SimpleSDMLayers._inner_type(first(layers))
    X = Matrix{R}(undef, length(layers), length(k))
    for i in eachindex(k)
        for j in eachindex(layers)
            X[j,i] = layers[j][k[i]]
        end
    end
    return X
end