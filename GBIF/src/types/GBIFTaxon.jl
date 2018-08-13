struct GBIFTaxon
   name::String
   scientific::String
   status::Symbol
   match::Symbol
   kingdom::Union{Nothing,Pair{String, Int64}}
   phylum::Union{Nothing,Pair{String, Int64}}
   class::Union{Nothing,Pair{String, Int64}}
   order::Union{Nothing,Pair{String, Int64}}
   family::Union{Nothing,Pair{String, Int64}}
   genus::Union{Nothing,Pair{String, Int64}}
   species::Union{Nothing,Pair{String, Int64}}
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
         r[l] = nothing
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
