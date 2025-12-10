"""
    PolygonDataset


This is an abstract type for all datasets supported by the package.
"""
abstract type PolygonDataset end 

"""
    Places

To be used when retrieving an arbitrary sized place. This can correspond to very
local (smaller admin areas) places, arbitrary locations as with the OSM service,
or any other data source where a more focused dataset type does not apply.
"""
struct Places <: PolygonDataset end 

"""
    Countries

To be used when retrieving country borders, although `GADM` uses it for internal
admin areas.
"""
struct Countries <: PolygonDataset end 

"""
    Land

To be used when retrieving land masses, without reference to administrative
areas.
"""
struct Land <: PolygonDataset end 

"""
    Lakes

To be used when retrieving the boundaries of lakes and other similar water
bodies.
"""
struct Lakes <: PolygonDataset end 

"""
    Ecoregions

Boundaries that are defined primarily w.r.t. biotic or environmental
characteristics, and that usually span across different administrative
boundaries.
"""
struct Ecoregions <: PolygonDataset end 

"""
    Bioregions

This is a largest unit than `Ecoregions`, used by `OneEarth`
"""
struct Bioregions <: PolygonDataset end 

""" 
    Oceans

Like `Lakes` but not like lakes; lakes with more water and salt.
"""
struct Oceans <: PolygonDataset end 

"""
    ParksAndProtected

Used for parks and protected areas, regardless of the jurisdiction that
establishes them (municipal, regional, national, etc).
"""
struct ParksAndProtected <: PolygonDataset end 