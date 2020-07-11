"""
    geotiff(tiff_file; left::T=-180.0, right::T=180.0, bottom::T=-90.0, top::T=90.0) where {T <: Number}

The geotiff function reads a geotiff file, and returns it as a matrix of the correct type.
"""
function geotiff(tiff_file; left::T=-180.0, right::T=180.0, bottom::T=-90.0, top::T=90.0) where {T <: Number}
    @assert right > left
    @assert top > bottom
    @assert left <= 180.0
    @assert right >= -180.0
    @assert top <= 90.0
    @assert bottom >= -90.0
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
