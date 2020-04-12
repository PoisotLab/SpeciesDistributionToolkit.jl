"""
    geotiff(tiff_file; T::Type=Float64)

The geotiff function reads a geotiff file, and returns it as a matrix of type
`T`.
"""
function geotiff(tiff_file; T::Type=Float64)
    # Register GDAL drivers
    GDAL.gdalallregister()

    # Load the dataset
    dataset = GDAL.gdalopen(tiff_file, GDAL.GA_ReadOnly)

    # Band
    band = GDAL.gdalgetrasterband(dataset, 1)

    # Matrix
    xs = GDAL.gdalgetrasterxsize(dataset)
    ys = GDAL.gdalgetrasterysize(dataset)

    bandtype = GDAL.gdalgetrasterdatatype(band)

    V = zeros(T, (xs, ys))
    GDAL.gdalrasterio(
        band,
        GDAL.GF_Read,
        0, 0, xs, ys,
        pointer(V),
        xs, ys,
        bandtype,
        0, 0
    )

    K = Array{Union{Nothing,T},2}(undef, ys, xs)
    for (i,r) in enumerate(reverse(1:size(V, 2)))
       K[i,:] = V[:,r]
    end

    this_min = minimum(V)

    for i in eachindex(K)
        K[i] = K[i] > this_min ? K[i] : nothing
    end

    return K

end
