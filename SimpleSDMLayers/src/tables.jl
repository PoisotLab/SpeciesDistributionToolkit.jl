Tables.istable(::Type{SDMLayer}) = true
Tables.rowaccess(::Type{SDMLayer}) = true
Tables.rows(layer::SDMLayer) = layer

# TODO Materializer