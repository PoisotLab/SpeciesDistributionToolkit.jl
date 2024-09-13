"""
    mask!(layer::SDMLayer, template::SDMLayer)

Updates the positions in the first layer to be those that have a value in the
second layer.
"""
function mask!(layer::SDMLayer, template::SDMLayer)
    @assert layer.crs == template.crs
    @assert layer.x == template.x
    @assert layer.y == template.y
    @assert size(layer) == size(template)
    layer.indices = layer.indices .& template.indices
    return layer
end

"""
    mask(layer::SDMLayer, template::SDMLayer)

Returns a copy of the first layer masked according to the second layer. See also `mask!`.
"""
function mask(layer::SDMLayer, template::SDMLayer)
    copied = copy(layer)
    return mask!(copied, template)
end

@testitem "We can get a mask of a layer" begin
    layer = SimpleSDMLayers.__demodata()
    template = nodata!(copy(layer), rand(values(layer)))
    @test length(mask(layer, template)) == length(template)
end