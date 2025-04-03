"""
    PolygonDownloadType

"""
abstract type PolygonDownloadType end

struct _File <: PolygonDownloadType end 
struct _Zip <: PolygonDownloadType end 
   
"""
    PolygonFileType
"""
abstract type PolygonFileType end

"""
    _GeoJSON
"""
struct _GeoJSON <: PolygonFileType end 
extension(::Type{_GeoJSON}) = ".geojson"

_read(::Type{_GeoJSON}, filename) = GJ.read(filename)

"""
    _Shapefile
"""
struct _Shapefile <: PolygonFileType end 
extension(::Type{_Shapefile}) = ".shp"

function _read(::Type{_Shapefile}, dir)
    dir_contents = readdir(dir)
    shp_filename = dir_contents[findfirst(contains(extension(_Shapefile)), dir_contents)]
    table = SF.Table(joinpath(dir, shp_filename))

    prj_path = joinpath(dir, dir_contents[findfirst(contains(".prj"), dir_contents)])
    ag_prj = AG.importESRI(read(prj_path, String))
    return table, ag_prj
end
