url(::RasterData{LUH2, LandCover}) = "https://luh.umd.edu/data.shtml"

blurb(::RasterData{LUH2, LandCover}) = md"""
LUH2 v2h Release (10/14/16): The updated release of the historical land-use
forcing dataset (LUH2 v2h) covers the period 850-2015 and corrects all known
issues and notices identified with the previous version (LUH2 v1.0h). This
dataset replaces the previously released dataset (LUH2 v1.0h). This product is
the result of a series of prototypes released previously, uses the established
data format, and will connect smoothly to gridded products for the future.
"""

downloadtype(::RasterData{LUH2, LandCover}) = _file
filetype(::RasterData{LUH2, LandCover}) = _netcdf

# Years supported by the historical data
years(::RasterData{LUH2, LandCover}) = Year.(850:2015)

# Layers
layers(::RasterData{LUH2, LandCover}) = ["c4ann", "secdf", "secma", "range", "c3per", "c3ann", "c3nfx", "pastr", "urban", "secmb", "primn", "c4per", "primf", "secdn"]
layerdescriptions(::RasterData{LUH2, LandCover}) = Dict([
    "c4ann" => "C4 annual crops",
    "secdf" => "Potentially forested secondary land",
    "secma" => "Secondary mean age",
    "range" => "Rangeland",
    "c3per" => "C3 perennial crops",
    "c3ann" => "C3 annual crops",
    "c3nfx" => "C3 nitrogen-fixing crops",
    "pastr" => "Managed pasture",
    "urban" => "Urban land",
    "secmb" => "Secondary mean biomass carbon density",
    "primn" => "Non-forested primary land",
    "c4per" => "",
    "primf" => "Forested primary land",
    "secdn" => "Potentially non-forested secondary land"
])

function source(
    data::RasterData{LUH2, LandCover};
    kwargs...
)
    dlurl = "https://luh.umd.edu/LUH2/LUH2_v2h/states.nc"
    return (
        url = dlurl,
        filename = lowercase("states.nc"),
        outdir = destination(data),
    )
end