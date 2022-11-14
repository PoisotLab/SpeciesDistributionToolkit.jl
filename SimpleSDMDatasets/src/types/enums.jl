"""
    RasterDownloadType

This enum stores the possible types of downloaded files. They are listed with
`instances(RasterDownloadType)`, and are currently limited to `_file` (a file,
can be read directly) and `_zip` (an archive, must be unzipped).
"""
@enum RasterDownloadType begin
    _file
    _zip
end

"""
    RasterFileType

This enum stores the possible types of returned files. They are listed with
`instances(RasterFileType)`.
"""
@enum RasterFileType begin
    _tiff
    _netcdf
    _ascii
end

"""
    RasterProjection

This enum stores the possible coordinate representation system of returned files. They are listed with `instances(RasterProjection)`.
"""
@enum RasterCRS begin
    _wgs84
    _nad83
end
