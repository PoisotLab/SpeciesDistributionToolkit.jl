function _find_span(n, m, M, pos)
    pos > M && return nothing
    pos < m && return nothing
    stride = (M - m) / n
    centers = (m + 0.5stride):stride:(M-0.5stride)
    span_pos = last(findmin(abs.(pos .- centers)))
    return (stride, centers[span_pos], span_pos)
end

"""
    geotiff(::Type{LT}, tiff_file; left=nothing, right=nothing, bottom=nothing, top=nothing) where {LT <: SimpleSDMLayer}

The geotiff function reads a geotiff file, and returns it as a matrix of the
correct type. The optional arguments `left`, `right`, `bottom`, and `left` are
defining the bounding box to read from the file. This is particularly useful if
you want to get a small subset from large files.

The first argument is the type of the `SimpleSDMLayer` to be returned.
"""
function geotiff(
    ::Type{LT},
    file::AbstractString,
    bandnumber::Integer=1;
    left = -180.0,
    right = 180.0,
    bottom = -90.0,
    top = 90.0
) where {LT<:SimpleSDMLayer}

    # This next block is reading the geotiff file, but also making sure that we
    # clip the file correctly to avoid reading more than we need.
    # This next block is reading the geotiff file, but also making sure that we
    # clip the file correctly to avoid reading more than we need.
    layer = ArchGDAL.read(file) do dataset

        transform = ArchGDAL.getgeotransform(dataset)
        wkt = ArchGDAL.getproj(dataset)

        # The data we need is pretty much always going to be stored in the first
        # band, but this is not the case for the future WorldClim data.
        band = ArchGDAL.getband(dataset, bandnumber)
        T = ArchGDAL.pixeltype(band)
        nodata = convert(T, ArchGDAL.getnodatavalue(band))

        # Get the correct latitudes
        minlon = transform[1]
        maxlat = transform[4]
        maxlon = minlon + size(band,1)*transform[2]
        minlat = maxlat - abs(size(band,2)*transform[6])

        left = isnothing(left) ? minlon : max(left, minlon)
        right = isnothing(right) ? maxlon : min(right, maxlon)
        bottom = isnothing(bottom) ? minlat : max(bottom, minlat)
        top = isnothing(top) ? maxlat : min(top, maxlat)

        lon_stride, lat_stride = transform[2], transform[6]
        
        width = ArchGDAL.width(dataset)
        height = ArchGDAL.height(dataset)

        #global lon_stride, lat_stride
        #global left_pos, right_pos
        #global bottom_pos, top_pos

        lon_stride, left_pos, min_width = _find_span(width, minlon, maxlon, left)
        _, right_pos, max_width = _find_span(width, minlon, maxlon, right)
        lat_stride, top_pos, max_height = _find_span(height, minlat, maxlat, top)
        _, bottom_pos, min_height = _find_span(height, minlat, maxlat, bottom)

        max_height, min_height = height .- (min_height, max_height) .+ 1

        # We are now ready to initialize a matrix of the correct type.
        buffer = Matrix{T}(undef, length(min_width:max_width), length(min_height:max_height))
        ArchGDAL.read!(dataset, buffer, bandnumber, min_height:max_height, min_width:max_width)
        buffer = convert(Matrix{Union{Nothing,eltype(buffer)}}, rotl90(buffer))
        replace!(buffer, nodata => nothing)
        LT(buffer, left_pos-0.5lon_stride, right_pos+0.5lon_stride, bottom_pos-0.5lat_stride, top_pos+0.5lat_stride)
    end

    return layer

end

function geotiff(layer::SimpleSDMPredictor{T}, file::AbstractString; nodata::T=convert(T, -9999)) where {T <: Number}
    array = layer.grid
    replace!(array, nothing => NaN)
    array = convert(Matrix{T}, array)
    dtype = eltype(array)
    array_t = reverse(permutedims(array, [2, 1]); dims=2)
    width, height = size(array_t)

    # Geotransform
    gt = zeros(Float64, 6)
    gt[1] = layer.left
    gt[2] = 2stride(layer, 1)
    gt[3] = 0.0
    gt[4] = layer.top
    gt[5] = 0.0
    gt[6] = -2stride(layer, 2)

    # Write
    prefix = first(split(last(splitpath(file)), '.'))
    ArchGDAL.create(prefix,
                driver=ArchGDAL.getdriver("MEM"),
                width=width, height=height,
                nbands=1, dtype=T,
                options=["COMPRESS=LZW"]) do dataset
    
        band = ArchGDAL.getband(dataset, 1)
        
        # Write data to band
        ArchGDAL.write!(band, array_t)

        # Write nodata and projection info
        ArchGDAL.setnodatavalue!(band, nodata)
        ArchGDAL.setgeotransform!(dataset, gt)
        ArchGDAL.setproj!(dataset, "EPSG:4326")

        # Write !
        ArchGDAL.write(dataset, file, driver=ArchGDAL.getdriver("GTiff"), options=["COMPRESS=LZW"])
    end
end

function geotiff(layer::SimpleSDMResponse{T}, file::AbstractString; nodata::T=convert(T, -9999)) where {T <: Number}
    geotiff(convert(SimpleSDMPredictor, layer), file; nodata=nodata)
end