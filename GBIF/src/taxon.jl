"""
**Get information about a taxon at any level**
"""
function taxon(name::String;
   rank::Union{Symbol,Nothing}=:SPECIES, strict::Bool=true, verbose::Bool=false,
   kingdom::Union{String,Nothing}=nothing, phylum::Union{String,Nothing}=nothing, class::Union{String,Nothing}=nothing,
   order::Union{String,Nothing}=nothing, family::Union{String,Nothing}=nothing, genus::Union{String,Nothing}=nothing)
   @assert rank ∈ [
      :DOMAIN, :CLASS, :CULTIVAR, :FAMILY, :FORM, :GENUS, :INFORMAL, :ORDER, :PHYLUM,
      :SECTION, :SUBCLASS, :VARIETY, :TRIBE, :KINGDOM, :SUBFAMILY , :SUBFORM,
      :SUBGENUS, :SUBKINGDOM, :SUBORDER, :SUBPHYLUM, :SUBSECTION , :SUBSERIES,
      :SUBSPECIES, :SUBTRIBE, :SUBVARIETY, :SUPERCLASS , :SUPERFAMILY, :SUPERORDER,
      :SPECIES
   ]
   args = Dict{String, Any}("name" => name, "strict" => strict, "verbose" => verbose)

   if rank != nothing
      args["rank"] = String(rank)
   end

   if kingdom != nothing
      args["kingdom"] = String(kingdom)
   end

   if phylum != nothing
      args["phylum"] = String(phylum)
   end

   if class != nothing
      args["class"] = String(class)
   end

   if order != nothing
      args["order"] = String(order)
   end

   if family != nothing
      args["family"] = String(family)
   end

   if genus != nothing
      args["genus"] = String(genus)
   end

   sp_s_url = gbifurl * "species/match"
   sp_s_req = HTTP.get(sp_s_url, query=args)
   if sp_s_req.status == 200
      body = JSON.parse(String(sp_s_req.body))
      # This will throw warnings for various reasons related to matchtypes
      matchtype = get(body, "matchType", "WELP...")
      # The first one will catch issues
      matchtype == "WELP..." && throw(ErrorException("Impossible to get information for $(name) at level $(rank)"))
      matchtype == "NONE" && throw(ErrorException("No match for $(name) at level $(rank) -- try with strict=false"))
      return GBIFTaxon(body)
   else
      throw(ErrorException("Impossible to retrieve information for $(name) -- HTML error code $(sp_s_req.status)"))
   end

end
