"""
**Representation of a GBIF taxon**

All taxonomic level fields can either be `missing`, or a pair linking the name
of the taxon/level to its unique key in the GBIF database.

`name` - the vernacular name of the taxon

`scientific` - the accepted scientific name of the species

`status` - the status of the taxon

`match` - the type of match

`kingdom` - a `Pair` linking the name of the kingdom to its unique ID

`phylum` - a `Pair` linking the name of the phylum to its unique ID

`class` - a `Pair` linking the name of the class to its unique ID

`order` - a `Pair` linking the name of the order to its unique ID

`family` - a `Pair` linking the name of the family to its unique ID

`genus` - a `Pair` linking the name of the genus to its unique ID

`species` - a `Pair` linking the name of the species to its unique ID

`confidence` - an `Int64` to note the confidence in the match

`synonym` - a `Boolean` indicating whether the taxon is a synonym
"""
struct GBIFTaxon
   name::String
   scientific::String
   status::Symbol
   match::Symbol
   kingdom::Union{Missing, Pair{String, Int64}}
   phylum::Union{Missing, Pair{String, Int64}}
   class::Union{Missing, Pair{String, Int64}}
   order::Union{Missing, Pair{String, Int64}}
   family::Union{Missing, Pair{String, Int64}}
   genus::Union{Missing, Pair{String, Int64}}
   species::Union{Missing, Pair{String, Int64}}
   confidence::Int64
   synonym::Bool
end

function GBIFTaxon(o::Dict{String, Any})
   levels = ["kingdom", "phylum", "class", "order", "family", "genus", "species"]
   r = Dict{Any,Any}()
   for l in levels
      if haskey(o, l)
         r[l] = Pair(o[l], o[l*"Key"])
      else
         r[l] = missing
      end
   end
   return GBIFTaxon(
      o["canonicalName"],
      o["scientificName"],
      Symbol(o["status"]),
      Symbol(o["matchType"]),
      r["kingdom"],
      r["phylum"],
      r["class"],
      r["order"],
      r["family"],
      r["genus"],
      r["species"],
      o["confidence"],
      o["synonym"]
   )
end
