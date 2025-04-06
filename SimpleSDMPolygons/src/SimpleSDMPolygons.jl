module SimpleSDMPolygons

const _data_storage_folders = first([
    Base.DEPOT_PATH...,
    homedir(),
])

const _POLYGON_PATH = get(ENV, "SDMLAYERS_PATH", joinpath(_data_storage_folders, "SimpleSDMPolygons"))
isdir(_POLYGON_PATH) || mkpath(_POLYGON_PATH)

using Downloads
using ZipArchives
using Proj 
using GeoJSON
using HTTP
using DataFrames, CSV 

const GJ = GeoJSON
import Shapefile as SF 
import GeoInterface as GI 
import ArchGDAL as AG

_GADM_MAX_LEVELS = Dict([r[Symbol("alpha-3")]=>r.max_level for r in eachrow(CSV.read(joinpath(@__DIR__, "..", "assets", "GADM.csv"), DataFrame))])

include(joinpath("types", "datasets.jl"))
export PolygonDataset
export Land, Oceans, Lakes, Countries, Places, Ecoregions, ParksAndProtected

include(joinpath("types", "providers.jl"))
export PolygonProvider
export EPA, NaturalEarth, OpenStreetMap, GADM, Resolv

include(joinpath("types", "filetypes.jl"))
export _file, _zip
export _geojson, _shapefile

include(joinpath("types", "specifiers.jl"))
export PolygonData

include(joinpath("types", "geometry.jl"))
export FeatureCollection, Feature, Polygon, MultiPolygon

include("interface.jl")
export provides 

include("downloader.jl")
export downloader
export downloadtype, filetype

include("keychecker.jl")
export keychecker

include(joinpath("providers", "epa.jl"))
include(joinpath("providers", "naturalearth.jl"))
include(joinpath("providers", "openstreetmap.jl"))
include(joinpath("providers", "gadm.jl"))
include(joinpath("providers", "resolv.jl"))


end # module PolygonInterface
