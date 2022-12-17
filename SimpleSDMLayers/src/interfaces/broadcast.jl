Base.BroadcastStyle(::Type{T}) where {T <: SimpleSDMLayer} = Broadcast.Style{T}()
Base.BroadcastStyle(
    ::Broadcast.Style{T},
    ::S,
) where {T <: SimpleSDMLayer, S <: Broadcast.BroadcastStyle} = Broadcast.Style{T}()
Base.BroadcastStyle(
    ::S,
    ::Broadcast.Style{T},
) where {T <: SimpleSDMLayer, S <: Broadcast.BroadcastStyle} = Broadcast.Style{T}()

Base.axes(layer::T) where {T <: SimpleSDMLayer} = (Base.OneTo(length(layer)),)
Base.broadcastable(layer::T) where {T <: SimpleSDMLayer} = layer

find_layer(bc::Base.Broadcast.Broadcasted) = find_layer(bc.args)
find_layer(args::Tuple) = find_layer(find_layer(args[1]), Base.tail(args))
find_layer(x) = x
find_layer(::Tuple{}) = nothing
find_layer(layer::T, rest) where {T <: SimpleSDMLayer} = layer
find_layer(::Any, rest) = find_aac(rest)

function Base.similar(
    bc::Base.Broadcast.Broadcasted{Broadcast.Style{T}},
    ::Type{ElType},
) where {T <: SimpleSDMLayer, ElType}
    @info "similar"
    layer = find_layer(bc)
    return similar(layer, ElType)
end

function Base.broadcasted(::Broadcast.Style{T}, f, layer::T) where {T <: SimpleSDMLayer}
    ElType = typeof(f(collect(layer)[1].value))
    dest = similar(layer, ElType)
    for cell in layer
        dest[cell.longitude, cell.latitude] = f(cell.value)
    end
    return dest
end

function Base.broadcasted(::Broadcast.Style{T}, f, layer::T, x) where {T <: SimpleSDMLayer}
    ElType = typeof(f(collect(layer)[1].value, x))
    dest = similar(layer, ElType)
    for cell in layer
        dest[cell.longitude, cell.latitude] = f(cell.value, x)
    end
    return dest
end

function Base.broadcasted(::Broadcast.Style{T}, f, x, layer::T) where {T <: SimpleSDMLayer}
    ElType = typeof(f(x, collect(layer)[1].value))
    dest = similar(layer, ElType)
    for cell in layer
        dest[cell.longitude, cell.latitude] = f(x, cell.value)
    end
    return dest
end

function Base.broadcasted(
    ::Broadcast.Style{T},
    f,
    layer1::T1,
    layer2::T2,
) where {T <: SimpleSDMLayer, T1 <: SimpleSDMLayer, T2 <: SimpleSDMLayer}
    @assert SimpleSDMLayers._layers_are_compatible(layer1, layer2)
    ElType = typeof(f(collect(layer1)[1].value, collect(layer2)[1].value))
    dest = similar(layer1, ElType)
    for cell in layer1
        dest[cell.longitude, cell.latitude] = f(cell.value, layer2[cell.longitude, cell.latitude])
    end
    return dest
end