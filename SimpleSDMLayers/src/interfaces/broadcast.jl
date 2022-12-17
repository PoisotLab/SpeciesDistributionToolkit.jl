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
    layer = finf_layer(bc)
    return similar(layer, ElType)
end

function Base.Broadcast.instantiate(
    bc::Base.Broadcast.Broadcasted{Broadcast.Style{T}},
) where {T <: SimpleSDMLayer}
    layer = find_layer(bc)
    return Base.Broadcast.Broadcasted(bc.f, bc.args, axes(layer))
end

function Base.broadcasted(::Broadcast.Style{T}, f, args...) where {T <: SimpleSDMLayer}
    @info f
    @info args
    @info length(args)
end

function copyto!(dest::T, bc::Base.Broadcast.Broadcasted{Broadcast.Style{T}},
) where {T <: SimpleSDMLayer}
@info "oh"
end