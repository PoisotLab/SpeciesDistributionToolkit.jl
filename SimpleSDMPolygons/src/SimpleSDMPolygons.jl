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

using TestItems

const GJ = GeoJSON
import Shapefile as SF
import GeoInterface as GI
import ArchGDAL as AG

import SimpleSDMDatasets

const _GADM_MAX_LEVELS = Dict([r[Symbol("alpha-3")] => r.max_level for r in eachrow(CSV.read(joinpath(@__DIR__, "..", "assets", "GADM.csv"), DataFrame))])

const _ONEEARTH_CODES = Dict([r.Code => Dict("Region" => String(r.Region), "Subregion" => r.Subregion, "Name" => r.Name) for r in eachrow(CSV.read(joinpath(@__DIR__, "..", "assets", "OneEarth.csv"), DataFrame))])

include(joinpath("types", "datasets.jl"))
export PolygonDataset
export Land, Oceans, Lakes, Countries, Places, Ecoregions, Bioregions, ParksAndProtected

include(joinpath("types", "providers.jl"))
export PolygonProvider
export EPA, NaturalEarth, OpenStreetMap, GADM, Resolve, OneEarth

include(joinpath("types", "filetypes.jl"))

include(joinpath("types", "specifiers.jl"))
export PolygonData

include(joinpath("types", "geometry.jl"))
export FeatureCollection, Feature, Polygon, MultiPolygon
export getname, uniqueproperties

# These are overloaded from SimpleSDMDatasets
include("overloads/interface.jl")
include("overloads/downloader.jl")
include("overloads/keychecker.jl")

# List of providers
include(joinpath("providers", "epa.jl"))
include(joinpath("providers", "naturalearth.jl"))
include(joinpath("providers", "openstreetmap.jl"))
include(joinpath("providers", "gadm.jl"))
include(joinpath("providers", "resolve.jl"))
include(joinpath("providers", "oneearth.jl"))

# Operations
include(joinpath("operations", "add.jl"))
include(joinpath("operations", "subtract.jl"))
include(joinpath("operations", "invert.jl"))
include(joinpath("operations", "clip.jl"))
include(joinpath("operations", "intersect.jl"))
export add, subtract, intersect, invert, clip

# Utility function
getpolygon(pd::T, args...; kwargs...) where {T<:PolygonData} = SimpleSDMDatasets.downloader(pd, args...; kwargs...)
export getpolygon

end # module PolygonInterface
