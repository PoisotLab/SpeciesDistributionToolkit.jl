Tables.istable(::Type{T}) where {T <: SimpleSDMLayer} = true
Tables.rowaccess(::Type{T}) where {T <: SimpleSDMLayer} = true
Tables.rows(layer::T) where {T <: SimpleSDMLayer} = layer
