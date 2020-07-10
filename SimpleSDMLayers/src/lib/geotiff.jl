"""
    geotiff(tiff_file; T::Type=Float64)

The geotiff function reads a geotiff file, and returns it as a matrix of the correct type.
"""
function geotiff(tiff_file; T::Type=Float64)
    ArchGDAL.read(tiff_file) do dataset
        band = ArchGDAL.getband(dataset, 1)
        width = ArchGDAL.width(dataset)
        height = ArchGDAL.height(dataset)
        pixel_type = ArchGDAL.pixeltype(band)
        buffer = Matrix{pixel_type}(undef, width, height)
        ArchGDAL.read!(dataset, buffer, 1)
    end

    buffer = rotl90(convert(Matrix{Union{Nothing,eltype(buffer)}}, buffer))
    buffer[buffer .== minimum(buffer)] .= nothing

    return buffer

end
