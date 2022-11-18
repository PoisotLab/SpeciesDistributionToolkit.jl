# We are a Tables.jl provider
Tables.istable(::Type{T}) where {T <: SimpleSDMLayer} = true

# We access data in a layer by rows (they are provided by iteration)
Tables.rowaccess(::Type{T}) where {T <: SimpleSDMLayer} = true

# 
function Tables.schema(layer::T) where {T <: SimpleSDMLayer}
    lon_type = eltype(longitudes(layer))
    lat_type = eltype(latitudes(layer))
    elm_type = eltype(l)
    colnames = [:longitude, :latitude, :value]
    coltypes = [lon_type, lat_type, elm_type]
    return Tables.schema(colnames, coltypes)
end

function Tables.rows(layer::T) where {T <: SimpleSDMLayer}
    return layer
end

function Tables.getcolumn(row, i::Int)
    if i == 1
        return row.first[1]
    elseif i == 2
        return row.first[2]
    end
    return row.second
end

function Tables.getcolumn(row, nm::Symbol)
    if nm == :longitude
        return row.first[1]
    elseif nm == :latitude
        return row.first[2]
    end
    return row.second
end
