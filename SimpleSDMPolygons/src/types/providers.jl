"""
    PolygonProvider
"""
abstract type PolygonProvider end 

"""
    EPA

This data is all hosted by the US Environmental Protection Agency (EPA), so
there's really no guarantee it will stay available day-to-day. 
"""
abstract type EPA <: PolygonProvider end 

"""
    GADM

Known for their server's reliable uptime!
"""
abstract type GADM <: PolygonProvider end 

"""
    NaturalEarth

It's literally a buncha GeoJSONs in a Github repo
"""
abstract type NaturalEarth <: PolygonProvider end 

"""
    OpenStreetMap

This provider uses the nominatim OSM Germany service to map a user-provided name
of any arbitrary place to an OSM ID, then uses the polygon creation service
hosted by OSM France to return a GeoJSON file.
"""
abstract type OpenStreetMap <: PolygonProvider end 

"""
    Resolve

"""
abstract type Resolve <: PolygonProvider end 

"""
    OneEarth

Ecoregions from https://www.oneearth.org/ - note that this is described as
"bioregions" by the provider, but is functionally similar to ecoregions. Both
`BioRegions` and `EcoRegions` work as types.
"""
abstract type OneEarth <: PolygonProvider end 


"""
    ESRI

Datasets from the ESRI dataset hub - https://hub.arcgis.com/datasets/.
"""
abstract type ESRI <: PolygonProvider end 
