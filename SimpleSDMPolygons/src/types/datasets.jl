"""
    PolygonDataset
"""
abstract type PolygonDataset end 

"""
    Countries
"""
struct Countries <: PolygonDataset end 

"""
    Places
"""
struct Places <: PolygonDataset end 

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

This is an _alias_ for `Ecoregions`
"""
const Bioregions = Ecoregions

""" 
    Oceans
"""
struct Oceans <: PolygonDataset end 

"""
    ParksAndProtected
"""
struct ParksAndProtected <: PolygonDataset end 