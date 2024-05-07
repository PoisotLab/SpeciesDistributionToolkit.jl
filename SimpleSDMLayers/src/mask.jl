function mask!(layer::SDMLayer, template::SDMLayer)
    @assert layer.crs == template.crs
    @assert layer.x == template.x
    @assert layer.y == template.y
    @assert size(layer) == size(template)
    layer.grid[findall(isequal(template.nodata), template.grid)] .= layer.nodata
    return layer
end

function mask(layer::SDMLayer, template::SDMLayer)
    copied = copy(layer)
    return mask!(copied, template)
end

@testitem "We can get a mask of a layer" begin
    layer = SimpleSDMLayers.__demodata()
    random_mask = rand(Bool, size(layer))
    template = SDMLayer{Bool}(grid=random_mask, nodata=typemin(Bool), x=layer.x, y=layer.y, crs=layer.crs)
    @test length(mask(layer, template)) == length(template)
end