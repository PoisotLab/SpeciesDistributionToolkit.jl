function _find_span(n, m, M, pos, side)
    side in [:left, :right, :bottom, :top] ||
        throw(ArgumentError("side must be one of :left, :right, :bottom, top"))

    pos > M && return nothing
    pos < m && return nothing
    stride = (M - m) / n
    centers = (m + 0.5stride):stride:(M - 0.5stride)
    pos_diff = abs.(pos .- centers)
    pos_approx = isapprox.(pos_diff, 0.5stride)
    if any(pos_approx)
        if side in [:left, :bottom]
            span_pos = findlast(pos_approx)
        elseif side in [:right, :top]
            span_pos = findfirst(pos_approx)
        end
    else
        span_pos = last(findmin(abs.(pos .- centers)))
    end
    return (stride, centers[span_pos], span_pos)
end

"""
    geotiff(file; bandnumber::Integer=1, left=nothing, right=nothing, bottom=nothing, top=nothing, driver)

The geotiff function reads a geotiff file, and returns it as a matrix of the
correct type. The optional arguments `left`, `right`, `bottom`, and `left` are
defining the bounding box to read from the file. This is particularly useful if
you want to get a small subset from large files.
"""
function _read_geotiff(
    file::AbstractString;
    bandnumber::Integer = 1,
    left = -180.0,
    right = 180.0,
    bottom = -90.0,
    top = 90.0,
    driver::String = "GTiff"
)
    @assert driver ∈ keys(ArchGDAL.listdrivers()) ||
            throw(ArgumentError("Not a valid driver."))

    # This next block is reading the geotiff file, but also making sure that we
    # clip the file correctly to avoid reading more than we need.
    layer = ArchGDAL.read(file) do dataset
        wkt = ArchGDAL.importPROJ4(ArchGDAL.getproj(dataset))
        # wkt = ArchGDAL.getproj(dataset)
        transform = ArchGDAL.getgeotransform(dataset)

        # The data we need is pretty much always going to be stored in the first
        # band, but this is not the case for the future WorldClim data.
        band = ArchGDAL.getband(dataset, bandnumber)
        T = ArchGDAL.pixeltype(band)

        # We need to check that the nodatavalue is represented in the correct pixeltype,
        # which is not always the case (cough CHELSA2 cough). If this is the case, trying to
        # convert the nodata value will throw an InexactError, so we can catch it and to
        # something about it.
        nodata = ArchGDAL.getnodatavalue(band)
        nodata = isnothing(nodata) ? typemin(T) : nodata

        # Get the correct latitudes
        minlon = transform[1]
        maxlat = transform[4]
        maxlon = minlon + size(band, 1) * transform[2]
        minlat = maxlat - abs(size(band, 2) * transform[6])

        left = isnothing(left) ? minlon : max(left, minlon)
        right = isnothing(right) ? maxlon : min(right, maxlon)
        bottom = isnothing(bottom) ? minlat : max(bottom, minlat)
        top = isnothing(top) ? maxlat : min(top, maxlat)

        lon_stride, lat_stride = transform[2], transform[6]

        width = ArchGDAL.width(dataset)
        height = ArchGDAL.height(dataset)

        lon_stride, left_pos, min_width = _find_span(width, minlon, maxlon, left, :left)
        _, right_pos, max_width = _find_span(width, minlon, maxlon, right, :right)
        lat_stride, top_pos, max_height = _find_span(height, minlat, maxlat, top, :top)
        _, bottom_pos, min_height = _find_span(height, minlat, maxlat, bottom, :bottom)

        max_height, min_height = height .- (min_height, max_height) .+ 1

        # We are now ready to initialize a matrix of the correct type.
        buffer =
            Matrix{T}(undef, length(min_width:max_width), length(min_height:max_height))
        ArchGDAL.read!(
            dataset,
            buffer,
            bandnumber,
            min_height:max_height,
            min_width:max_width,
        )
        return SDMLayer(
            rotl90(buffer),
            rotl90(buffer .!= nodata),
            (left_pos - 0.5lon_stride, right_pos + 0.5lon_stride),
            (bottom_pos - 0.5lat_stride, top_pos + 0.5lat_stride),
            string(wkt),
        )
    end

    return layer
end

"""
    geotiff(file::AbstractString, layer::SDMLayer; kwargs...)

Write a single `layer` to a `file`.
"""
function _write_geotiff(
    file::AbstractString,
    layer::SDMLayer;
    driver::String = "GTiff",
    compress = "LZW",
)
    @assert driver ∈ keys(ArchGDAL.listdrivers()) ||
            throw(ArgumentError("Not a valid driver."))
    #@assert compress ∈ keys(ArchGDAL.listcompress()) || throw(ArgumentError("Not a valid compression."))

    array_t = _prepare_layer_for_burnin(layer, nodata)
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
    ArchGDAL.create(prefix;
        driver = ArchGDAL.getdriver(driver),
        width = width, height = height,
        nbands = 1, dtype = T,
        options = ["COMPRESS=$compress"]) do dataset
        band = ArchGDAL.getband(dataset, 1)

        # Write data to band
        ArchGDAL.write!(band, array_t)

        # Write nodata and projection info
        ArchGDAL.setnodatavalue!(band, nodata)
        ArchGDAL.setgeotransform!(dataset, gt)
        ArchGDAL.setproj!(dataset, "EPSG:4326")

        # Write !
        return ArchGDAL.write(
            dataset,
            file;
            driver = ArchGDAL.getdriver("GTiff"),
            options = ["COMPRESS=$compress"],
        )
    end
    isfile(prefix) && rm(prefix)
    return file
end

function _prepare_layer_for_burnin(layer::SDMLayer{T}, nodata::T) where {T <: Number}
    array = copy(layer.grid)
    array[findall(layer.indices)] .= nodata
    array_t = reverse(permutedims(array, [2, 1]); dims = 2)
    return array_t
end

"""
    geotiff(file::AbstractString, layers::Vector{SDMLayer{T}}; nodata::T=convert(T, -9999)) where {T <: Number}

Stores a series of `layers` in a `file`, where every layer in a band. See
`geotiff` for other options.
"""
function _write_geotiff(
    file::AbstractString,
    layers::Vector{SDMLayer{T}};
    nodata::T = convert(T, -9999),
    driver::String = "GTiff",
    compress::String = "LZW",
) where {T <: Number}
    @assert driver ∈ keys(ArchGDAL.listdrivers()) ||
            throw(ArgumentError("Not a valid driver."))
    # to be uncommented once ths getcompressions fcn exists
    #@assert compress ∈ keys(ArchGDAL.listcompress()) || throw(ArgumentError("Not a valid compression."))

    bands = 1:length(layers)
    SimpleSDMLayers._layers_are_compatible(layers)
    width, height = size(_prepare_layer_for_burnin(layers[1], nodata))

    # Geotransform
    gt = zeros(Float64, 6)
    gt[1] = layers[1].left
    gt[2] = 2stride(layers[1], 1)
    gt[3] = 0.0
    gt[4] = layers[1].top
    gt[5] = 0.0
    gt[6] = -2stride(layers[1], 2)

    # Write
    prefix = first(split(last(splitpath(file)), '.'))
    ArchGDAL.create(prefix;
        driver = ArchGDAL.getdriver(driver),
        width = width, height = height,
        nbands = length(layers), dtype = T,
        options = ["COMPRESS=$compress"]) do dataset
        for i in 1:length(bands)
            band = ArchGDAL.getband(dataset, i)

            # Write data to band
            ArchGDAL.write!(band, _prepare_layer_for_burnin(layers[i], nodata))

            # Write nodata and projection info
            ArchGDAL.setnodatavalue!(band, nodata)
        end
        ArchGDAL.setgeotransform!(dataset, gt)
        ArchGDAL.setproj!(dataset, "EPSG:4326")

        # Write !
        return ArchGDAL.write(
            dataset,
            file;
            driver = ArchGDAL.getdriver(driver),
            options = ["COMPRESS=$compress"],
        )
    end
    isfile(prefix) && rm(prefix)
    return file
end

@testitem "We can write a GeoTiff file" begin
    layer = SDMLayer(RasterData(EarthEnv, LandCover); layer = 1)
    D = eltype(layer)

    f = tempname()
    
    SpeciesDistributionToolkit._write_geotiff(
        f,
        [layer];
        driver = "GTiff",
        nodata = typemax(D),
    )

    @test isfile(f)
end