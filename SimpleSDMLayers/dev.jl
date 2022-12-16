Base.BroadcastStyle(::Type{T}) where {T <: SimpleSDMLayer} = Broad
Base.similar(bc::Broadcasted{SimpleSDMLayerBoradcast}, ::Type{})

layer = SimpleSDMResponse(rand(100, 100))

f = (x) -> 2x

f.(layer)