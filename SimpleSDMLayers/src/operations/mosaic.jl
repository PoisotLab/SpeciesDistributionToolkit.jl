"""
    mosaic(f, stack::Vector{<:SDMLayer})

Returns a layer that is the application of `f` to the values at each cell in the
array of layers given as the second argument.
"""
function mosaic(f, stack::Vector{<:SDMLayer})
    @assert SimpleSDMLayers._layers_are_compatible(stack)
    v0 = f(first.(stack))
    output = similar(first(stack), typeof(v0))
    idx = reduce(.|, [x.indices for x in stack])
    for i in findall(idx)
        v = filter(!isnothing, [layer[i] for layer in stack])
        output[i] = f(v)
    end
    return output
end
