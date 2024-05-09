"""
    mosaic(f, layers::Vector{<:SDMLayer})

For overlapping layers only!!!
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
