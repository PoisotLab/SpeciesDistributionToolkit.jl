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
GBIF 1425221362	Canis lupus Linnaeus, 1758
~~~~





Note that the object returned is of the `Occurrence` type -- this provides a
simple mapping on the interpreted output from GBIF API, and adds some parsing
(like dates).

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
length(sp_set)
~~~~~~~~~~~~~


~~~~
40
~~~~





Of course this can rapidly get tedious, so we can complete the entire request at
once:

~~~~{.julia}
complete!(sp_set)
length(sp_set)
~~~~~~~~~~~~~


~~~~
1012
~~~~





All `Occurrences` objects are iterators, so we can apply functions like `map`,
and `filter` to them -- for example, to get the list of countries in which we
have observations:

~~~~{.julia}
map(x -> x.country, sp_set) |> unique |> sort
~~~~~~~~~~~~~


~~~~
20-element Array{String,1}:
 "Australia"                
 "Belgium"                  
 "Denmark"                  
 "Ecuador"                  
 "Estonia"                  
 "French Guiana"            
 "Hungary"                  
 "Iran, Islamic Republic of"
 "Israel"                   
 "Mexico"                   
 "Mongolia"                 
 "Norway"                   
 "Pakistan"                 
 "Palestine, State Of"      
 "Philippines"              
 "Poland"                   
 "Saudi Arabia"             
 "Sweden"                   
 "United Kingdom"           
 "United States"
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
length(sp_set)
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





If we are unhappy with the results after quality control, we can restart the
data query:

~~~~{.julia}

restart!(sp_set)
complete!(sp_set)
~~~~~~~~~~~~~

