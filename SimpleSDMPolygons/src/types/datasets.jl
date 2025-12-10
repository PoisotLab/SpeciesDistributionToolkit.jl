"""
    PolygonDataset
"""
abstract type PolygonDataset end 

"""
    Places
"""
struct Places <: PolygonDataset end 

"""
    Countries
"""
struct Countries <: PolygonDataset end 

"""
    Land
"""
struct Land <: PolygonDataset end 

"""
    Lakes
"""
struct Lakes <: PolygonDataset end 

"""
    Ecoregions
"""
struct Ecoregions <: PolygonDataset end 

"""
    Bioregions

This is a largest unit than `Ecoregions`, used by `OneEarth`
"""
struct Bioregions <: PolygonDataset end 

""" 
    Oceans
"""
struct Oceans <: PolygonDataset end 

"""
    ParksAndProtected
"""
struct ParksAndProtected <: PolygonDataset end 