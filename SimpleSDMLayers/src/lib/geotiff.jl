function geotiff(tiff_file; T::Type=Float64)
    # Register GDAL drivers
    GDAL.registerall()

    # Load the dataset
    dataset = GDAL.open(tiff_file, GDAL.GA_ReadOnly)

    # Band
    band = GDAL.getrasterband(dataset, 1)

    # Matrix
    xs = GDAL.getrasterxsize(dataset)
    ys = GDAL.getrasterysize(dataset)

    bandtype = GDAL.getrasterdatatype(band)

    V = zeros(T, (xs, ys))

    GDAL.rasterio(
        band,
        GDAL.GF_Read,
        0, 0, xs, ys,
        pointer(V),
        xs, ys,
        GDAL.getrasterdatatype(band),
        0, 0
        )

    K = zeros(T, (ys, xs))
    for (i,r) in enumerate(reverse(1:size(V, 2)))
        K[i,:] = V[:,r]
    end

    this_min = minimum(V)

    for i in eachindex(K)
        K[i] = K[i] > this_min ? K[i] : NaN
    end

    return K

end
