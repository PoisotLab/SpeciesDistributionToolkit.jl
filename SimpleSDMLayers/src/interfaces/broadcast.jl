Base.broadcastable(layer::SimpleSDMResponse) = layer
Base.BroadcastStyle(::Type{<:SimpleSDMResponse}) = Broadcast.Style{SimpleSDMResponse}()

Base.broadcastable(layer::SimpleSDMPredictor) = similar(layer)
Base.BroadcastStyle(::Type{<:SimpleSDMPredictor}) = Broadcast.Style{SimpleSDMPredictor}()

#=
"""
   Broadcast.broadcast(f, L::LT) where {LT <: SimpleSDMLayer}

TODO
"""
function Base.Broadcast.broadcast(f, L::LT) where {LT <: SimpleSDMLayer}
    newgrid = similar(L)
    for i in L
        newgrid[i.first] = f(i.second)
    end
    return newgrid
end
=#