"""
**Get information about a taxon at any level**
"""
function taxon(name::String;
  rank::Union{Symbol,Void}=:SPECIES, strict::Bool=true, verbose::Bool=false,
  kingdom::Union{String, Void}=nothing, phylum::Union{String, Void}=nothing, class::Union{String, Void}=nothing,
  order::Union{String, Void}=nothing, family::Union{String, Void}=nothing, genus::Union{String, Void}=nothing)
  @assert rank ∈ [
    :DOMAIN, :CLASS, :CULTIVAR, :DOMAIN, :FAMILY, :FORM, :GENUS, :INFORMAL,
    :ORDER, :PHYLUM, :SECTION, :SUBCLASS, :VARIETY, :TRIBE, :KINGDOM, :SUBFAMILY ,
    :SUBFORM, :SUBGENUS, :SUBKINGDOM, :SUBORDER, :SUBPHYLUM, :SUBSECTION ,
    :SUBSERIES, :SUBSPECIES, :SUBTRIBE, :SUBVARIETY, :SUPERCLASS ,
    :SUPERFAMILY, :SUPERORDER, :SPECIES
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
  sp_s_req = Requests.get(sp_s_url, query=args)
  if sp_s_req.status == 200
    body = Requests.json(sp_s_req)
    return body
  else
     warn("unable to retrieve taxon $(name) (error $(sp_s_req.status))")
  end

end
