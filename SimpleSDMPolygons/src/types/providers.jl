"""
    PolygonProvider
"""
abstract type PolygonProvider end 

"""
    EPA

This data is all hosted by the US Environmental Protection Agency (EPA), so there's really no guarantee it will stay available day-to-day. 
"""
abstract type EPA <: PolygonProvider end 

"""
    UCDavis

Known for their server's reliable uptime!
"""
abstract type UCDavis <: PolygonProvider end 

"""
    NaturalEarth

It's literally a buncha GeoJSONs in a Github repo
"""
abstract type NaturalEarth <: PolygonProvider end 

"""
    OpenStreetMap

It's specifically openstreetmap.fr, and a python script that does...something...and spits out a GeoJSON. OuvertRueCarte. Is that anything.
"""
abstract type OpenStreetMap <: PolygonProvider end 
