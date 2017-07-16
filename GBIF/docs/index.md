# GBIF wrapper for Julia

The aim of this module is to provide a *simple* way to get data about species
occurrences from [GBIF]. It comes with a minimal number of functions and types.

[GBIF]: http://gbif.org/

~~~~{.julia}
using GBIF
~~~~~~~~~~~~~





To get a single occurrence of known ID, use

~~~~{.julia}
occurrence(1425221362)
~~~~~~~~~~~~~


~~~~
GBIF.Occurrence(1425221362, "9ea87732-b88e-488d-a02b-3dc6e9b885e0", "46fec3
80-8e1d-11dd-8679-b8a03c50a862", "NO", :HUMAN_OBSERVATION, 1, 59.423621, 11
.040923, nothing, 2017-01-07T00:00:00, Symbol[:GEODETIC_DATUM_ASSUMED_WGS84
], 5219173, :SPECIES, :Mammalia, "Canis lupus Linnaeus, 1758")
~~~~


