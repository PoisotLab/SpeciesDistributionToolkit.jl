function rescale!(layer::SDMLayer)
    m, M = extrema(layer)
    layer.grid .-= m
    layer.grid ./= (M-m)
    return layer
end

function rescale!(layer::SDMLayer, m, M)
    rescale!(layer)
    layer.grid .*= (M-m)
    layer.grid .+= m
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
    @test -1.5 ≈ minimum(layer)
    @test 2.6 ≈ maximum(layer)
end

function quantize!(layer::SDMLayer)
    ef = StatsBase.ecdf(values(layer))
    map!(ef, layer.grid, layer.grid)
    return layer
end

function quantize!(layer::SDMLayer, n::Integer)
    quantize!(layer)
    map!(x -> round(x*(n+1), digits=0)/(n+1), layer.grid, layer.grid)
    return layer
end

function quantize(layer::SDMLayer, args...)
    lc = copy(layer)
    quantize!(lc, args...)
    return lc
end