function _get_asc_field(lines, field, type)
    line_id = findfirst(line -> startswith(line, field), lines)
    return parse(type, last(split(lines[line_id], " "))), line_id
end

"""
    ascii(file::AbstractString, datatype::Type{T}=Float64) where {T <: Number}

Reads the content of a grid file to a `SimpleSDMPredictor`, the type of which is
given by the `datatype` argument.
"""
function ascii(
    ::Type{LT},
    file::AbstractString,
    datatype::Type{T} = Float64,
) where {LT <: SimpleSDMLayer, T <: Number}
    lines = lowercase.(readlines(file))
    # Get the information
    ncols, ncols_line = _get_asc_field(lines, "ncols", Int64)
    nrows, nrows_line = _get_asc_field(lines, "nrows", Int64)
    xl, xl_line = _get_asc_field(lines, "xllcorner", Float64)
    yl, yl_line = _get_asc_field(lines, "yllcorner", Float64)
    cs, cs_line = _get_asc_field(lines, "cellsize", Float64)
    nodata, nodata_line = _get_asc_field(lines, "nodata", datatype)
    # Read the data
    M = zeros(datatype, (ncols, nrows))
    data_start = nodata_line + 1
    data_end = length(lines)
    for line_id in data_start:data_end
        M[:, nrows - (line_id - (data_start))] = parse.(datatype, split(lines[line_id]))
    end
    # Put data in the grid
    grid = convert(Matrix{Union{datatype, Nothing}}, permutedims(M))
    for i in eachindex(M)
        if grid[i] == nodata
            grid[i] = nothing
        end
    end
    return LT(grid, xl, xl + cs * ncols, yl, yl + cs * nrows)
end

function ascii(file::AbstractString, datatype::Type{T} = Float64) where {T <: Number}
    return ascii(SimpleSDMPredictor, file, datatype)
end

"""
    ascii(layer::SimpleSDMPredictor{T}, file::AbstractString; nodata::T=convert(T, -9999)) where {T <: Number}

Writes a `layer` to a grid file, with a given `nodata` value. The layer must store numbers.
"""
function ascii(
    file::AbstractString,
    layer::SimpleSDMPredictor{T};
    nodata::T = convert(T, -9999),
) where {T <: Number}
    if !(stride(layer, 1) ≈ stride(layer, 2))
        throw(
            DimensionMismatch(
                "The cells of the layer to write must be square (i.e. both values of stride must be equal)",
            ),
        )
    end
    open(file, "w") do io
        write(io, "ncols $(size(layer, 2))\n")
        write(io, "nrows $(size(layer, 1))\n")
        write(io, "cellsize $(2*stride(layer)[1])\n")
        write(io, "xllcorner $(layer.left)\n")
        write(io, "yllcorner $(layer.bottom)\n")
        write(io, "nodata_value $(nodata)\n")
        for row in reverse(1:size(layer.grid, 1))
            for el in layer.grid[row, :]
                if isnothing(el)
                    write(io, "$(nodata) ")
                else
                    write(io, "$(el) ")
                end
            end
            write(io, "\n")
        end
    end
    return file
end

"""
    ascii(layer::SimpleSDMResponse{T}, file::AbstractString; nodata::T=convert(T, -9999)) where {T <: Number}

Writes a `layer` to a grid file, with a given `nodata` value. The layer must store numbers.
"""
function ascii(
    layer::SimpleSDMResponse{T},
    file::AbstractString;
    nodata::T = convert(T, -9999),
) where {T <: Number}
    return ascii(convert(SimpleSDMPredictor, layer), file; nodata = nodata)
end
