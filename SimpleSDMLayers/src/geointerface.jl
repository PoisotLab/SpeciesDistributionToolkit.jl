GeoInterface.israster(::SDMLayer) = true
GeoInterface.trait(::SDMLayer) = RasterTrait()
GeoInterface.crs(layer::SDMLayer) = layer.crs

@testitem "We can use the GeoInterface" begin
    import GeoInterface
    layer = convert(SDMLayer{Float16}, SimpleSDMLayers.__demodata(; reduced=true))
    GeoInteface.testraster(layer)
end
