Base.BroadcastStyle(::Type{<:SDMLayer}) = Broadcast.Style{SDMLayer}()
Base.BroadcastStyle(::Broadcast.Style{SDMLayer}, ::S,) where {S<:Broadcast.BroadcastStyle} = Broadcast.Style{SDMLayer}()
Base.BroadcastStyle(::S, ::Broadcast.Style{SDMLayer}) where {S<:Broadcast.BroadcastStyle} = Broadcast.Style{SDMLayer}()

Base.axes(layer::SDMLayer) = (Base.OneTo(length(layer)),)
Base.broadcastable(layer::SDMLayer) = layer

__bc_find_layer(bc::Broadcast.Broadcasted) = __bc_find_layer(bc.args)
__bc_find_layer(args::Tuple) = __bc_find_layer(__bc_find_layer(args[1]), Base.tail(args))
__bc_find_layer(x) = x
__bc_find_layer(::Tuple{}) = nothing
__bc_find_layer(layer::SDMLayer, rest) = layer
__bc_find_layer(::Any, rest) = __bc_find_layer(rest)

function Base.similar(bc::Broadcast.Broadcasted{Broadcast.Style{SDMLayer}}, ::Type{ElType}) where {ElType}
    @info "into similar"
    layer = __bc_find_layer(bc)
    @info "Layer found"
    return similar(layer, ElType)
end

function Base.broadcasted(::Broadcast.Style{SDMLayer}, f, layer::SDMLayer)
    ElType = typeof(f(first(values(layer))))
    dest = similar(layer, ElType)
    for index in findall(!isequal(layer.nodata), layer.grid)
        dest[index] = f(layer[index])
    end
    nodata!(dest, convert(ElType, layer.nodata))
    return dest
end

function Base.broadcasted(::Broadcast.Style{SDMLayer}, f, layer::SDMLayer, x)
    ElType = typeof(f(first(values(layer)), x))
    dest = similar(layer, ElType)
    for index in findall(!isequal(layer.nodata), layer.grid)
        dest[index] = f(layer[index], x)
    end
    nodata!(dest, convert(ElType, layer.nodata))
    return dest
end

function Base.broadcasted(::Broadcast.Style{SDMLayer}, f, x, layer::SDMLayer)
    ElType = typeof(f(x, first(values(layer))))
    dest = similar(layer, ElType)
    for index in findall(!isequal(layer.nodata), layer.grid)
        dest[index] = f(x, layer[index])
    end
    nodata!(dest, convert(ElType, layer.nodata))
    return dest
end

@testitem "We can broadcast over a layer" begin
    layer = SDMLayers.__demodata(reduced=true)
    doubled = 0x02 .* layer
    @test doubled isa SDMLayer
    @test doubled[1, 1] == 2layer[1, 1]
end

@testitem "Broadcasting preserves the nodata correctly" begin
    m = rand(0:6, (10, 10))
    m[2, 2] = m[3, 3] = 0
    layer = SDMLayer(m, nodata=0)
    added = layer .+ 1
    @test added isa SDMLayer
    @test length(added) == length(layer)
end

@testitem "Broadcasting preserves the nodata correctly even with a change of type" begin
    m = rand(0:6, (10, 10))
    m[2, 2] = m[3, 3] = 0
    layer = SDMLayer(m, nodata=0)
    cosed = cos.(layer)
    @test cosed isa SDMLayer
    @test length(cosed) == length(layer)
    @test cosed.nodata == convert(eltype(cosed), layer.nodata)
end

function Base.broadcasted(::Broadcast.Style{SDMLayer}, f, l1::SDMLayer, l2::SDMLayer)
    #@assert SimpleSDMLayers._layers_are_compatible(layer1, layer2)
    ElType = typeof(f(first(values(l1)), first(values(l2))))
    dest = similar(l1, ElType)
    for index in CartesianIndices(l1)
        dest[index] = f(l1[index], l2[index])
    end
    nodata!(dest, convert(ElType, l1.nodata))
    return dest
end

@testitem "We can do layer-layer broadcast operations" begin
    m = rand(0:6, (10, 10))
    m[2, 2] = m[3, 3] = 0
    l1 = SDMLayer(m, nodata=0)
    l2 = l1 .+ 1
    @test typeof(l1) == typeof(l2)
    @test l1.nodata == l2.nodata
    @test l1 .- l2 isa SDMLayer
    @test extrema(l2 .- l1) == (1, 1)
end