function rescale!(layer::SDMLayer)
    m, M = extrema(layer)
    layer.grid .-= m
    layer.grid ./= (M-m)
    return layer
end

function rescale!(layer::SDMLayer, m, M)
    rescale!(layer)
    layer .*= (M-m)
    layer .+= m
    return layer
end

function rescale(layer::SDMLayer, args...)
    return rescale!(copy(layer), args...)
end

@testitem "We can rescale a layer between 0 and 1" begin
    layer = convert(SDMLayer{Float16}, SimpleSDMLayers.__demodata())
    rescale!(layer)
    @test iszero(minimum(layer))
    @test isone(maximum(layer))
end

@testitem "We can rescale a layer between m and M" begin
    layer = convert(SDMLayer{Float16}, SimpleSDMLayers.__demodata())
    rescale!(layer, -1.5, 2.6)
    @test isequal(-1.5)(minimum(layer))
    @test isequal(2.6)(maximum(layer))
end