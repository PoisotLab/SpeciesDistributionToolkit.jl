# GBIF wrapper for Julia

The aim of this module is to provide a *simple* way to get data about species
occurrences from [GBIF]. It comes with a minimal number of functions and types.

[GBIF]: http://gbif.org/

For an example application, see [this notebook][birds].

[birds]: https://nbviewer.jupyter.org/github/EcoJulia/GBIF.jl/blob/master/docs/ukbirds.nbconvert.ipynb

~~~~{.julia}
using GBIF
~~~~~~~~~~~~~





## Get a single observation

To get a single occurrence of known ID, use

~~~~{.julia}
occurrence(1425221362)
~~~~~~~~~~~~~


~~~~
GBIF.Occurrence(1425221362, "9ea87732-b88e-488d-a02b-3dc6e9b885e0", "46fec3
80-8e1d-11dd-8679-b8a03c50a862", "NO", "NO", "Norway", :HUMAN_OBSERVATION, 
1, 59.423621, 11.040923, nothing, nothing, "WGS84", 2017-01-07T00:00:00, Sy
mbol[:GEODETIC_DATUM_ASSUMED_WGS84], 5219173, 1, 44, 359, 732, 9701, 521914
2, 5219173, "Animalia", "Chordata", "Mammalia", "Carnivora", "Canidae", "Ca
nis", "Canis lupus", :SPECIES, "Canis lupus Linnaeus, 1758", "Canis", "Ulv"
, "Åse Paulsen Thon", "http://creativecommons.org/licenses/by/4.0/legalcod
e")
~~~~





Note that the object returned is of the `Occurrence` type -- this provides a
simple mapping on the raw output from GBIF API, and adds some parsing.

The fields that are part of `Occurrence` are

~~~~{.julia}
fieldnames(Occurrence)
~~~~~~~~~~~~~


~~~~
36-element Array{Symbol,1}:
 :key              
 :datasetKey       
 :publishingOrgKey 
 :publishingCountry
 :countryCode      
 :country          
 :basisOfRecord    
 :individualCount  
 :latitude         
 :longitude        
 :precision        
 :uncertainty      
 :geodetic         
 :date             
 :issues           
 :taxonKey         
 :kingdomKey       
 :phylumKey        
 :classKey         
 :orderKey         
 :familyKey        
 :genusKey         
 :speciesKey       
 :kingdom          
 :phylum           
 :class            
 :order            
 :family           
 :genus            
 :species          
 :rank             
 :name             
 :generic          
 :vernacular       
 :observer         
 :license
~~~~





## Look for occurrence data

To look for occurrence data, we need to use some parameters. For example, all
geo-referenced observations of *Mus musculus* in 1999:

~~~~{.julia}
gimme_some_species = Dict("scientificName" => "Mus musculus", "year" => 1999, "hasCoordinate" => true)
sp_set = occurrences(gimme_some_species)
~~~~~~~~~~~~~





The first line is a series of filters, and the second line uses the
`occurrences` function to retrieve data. By default, only the first 20 results
are returned. We can look at the `sp_set.count` value to see that there are more
records.

We can keep growing this object by looking at the next page:

~~~~{.julia}
next!(sp_set)
length(sp_set.occurrences)
~~~~~~~~~~~~~


~~~~
40
~~~~





Of course this can rapidly get tedious, so we can complete the entire request at
once:

~~~~{.julia}
complete!(sp_set)
length(sp_set.occurrences)
~~~~~~~~~~~~~


~~~~
1012
~~~~





## Filtering data based on quality

There are a number of filters for data quality. All of these functions take an
occurrence as an input, and return `true` if it passes, and `false` if it
doesn't.

| function                        | purpose                                 |
|:--------------------------------|:----------------------------------------|
| `have_both_coordinates`         | both latitude and longitude are present |
| `have_neither_zero_coordinates` | the coordinate of the point is not 0,0  |
| `have_no_zero_coordinates`      | one of the coordinates can be 0.0       |
| `have_no_issues`                | the occurrence has no known issue       |

An efficient way to apply these filters is to use the `qualitycontrol!`
function:

~~~~{.julia}
qualitycontrol!(sp_set)
length(sp_set.occurrences)
~~~~~~~~~~~~~


~~~~
231
~~~~





By default, it will apply `have_no_issues` to the observations. Note that this
is a quite stringent filter, and may not be what is needed. The
`qualitycontrol!` function modifies an `Occurrences` object. If used from the
REPL with the `verbose` keyword set to `true`, this will tell you how many
records are left after each step.

It is easy to define custom filters -- for example, a filter that would only
keep species from Canada, could be defined as:

~~~~{.julia}
function is_from_canada(o::Occurrence)
  get(o, "publishingCountry", nothing) == "CA"
end
~~~~~~~~~~~~~


