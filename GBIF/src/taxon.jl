"""
**Get information about a taxon at any level**

    taxon(name::String)

This function will look for a taxon by its (scientific) name in the GBIF
reference taxonomy.

Optional arguments are

- `rank::Union{Symbol,Nothing}=:SPECIES` -- the rank of the taxon you want. This
  is part of a controlled vocabulary, and can only be one of `:DOMAIN`,
  `:CLASS`, `:CULTIVAR`, `:FAMILY`, `:FORM`, `:GENUS`, `:INFORMAL`, `:ORDER`,
  `:PHYLUM,`, `:SECTION`, `:SUBCLASS`, `:VARIETY`, `:TRIBE`, `:KINGDOM`,
  `:SUBFAMILY`, `:SUBFORM`, `:SUBGENUS`, `:SUBKINGDOM`, `:SUBORDER`,
  `:SUBPHYLUM`, `:SUBSECTION`, `:SUBSPECIES`, `:SUBTRIBE`, `:SUBVARIETY`,
  `:SUPERCLASS`, `:SUPERFAMILY`, `:SUPERORDER`, and `:SPECIES`

- `strict::Bool=true` -- whether the match should be strict, or fuzzy

Finally, one can also specify other levels of the taxonomy, using  `kingdom`,
`phylum`, `class`, `order`, `family`, and `genus`, all of which can either be
`String` or `Nothing`.

If a match is found, the result will be given as a `GBIFTaxon`. If not, this
function will return `nothing` and give a warning.
"""
function taxon(name::String;
    rank::Union{Symbol,Nothing}=:SPECIES, strict::Bool=true,
    kingdom::Union{String,Nothing}=nothing, phylum::Union{String,Nothing}=nothing, class::Union{String,Nothing}=nothing,
    order::Union{String,Nothing}=nothing, family::Union{String,Nothing}=nothing, genus::Union{String,Nothing}=nothing)
    @assert rank ∈ [
        :DOMAIN, :CLASS, :CULTIVAR, :FAMILY, :FORM, :GENUS, :INFORMAL, :ORDER, :PHYLUM,
        :SECTION, :SUBCLASS, :VARIETY, :TRIBE, :KINGDOM, :SUBFAMILY, :SUBFORM,
        :SUBGENUS, :SUBKINGDOM, :SUBORDER, :SUBPHYLUM, :SUBSECTION, :SUBSERIES,
        :SUBSPECIES, :SUBTRIBE, :SUBVARIETY, :SUPERCLASS, :SUPERFAMILY, :SUPERORDER,
        :SPECIES
    ]
    args = Dict{String,Any}("name" => name, "strict" => strict)

    isnothing(rank) || (args["rank"] = String(rank))
    isnothing(kingdom) || (args["kingdom"] = String(kingdom))
    isnothing(phylum) || (args["phylum"] = String(phylum))
    isnothing(class) || (args["class"] = String(class))
    isnothing(order) || (args["order"] = String(order))
    isnothing(family) || (args["family"] = String(family))
    isnothing(genus) || (args["genus"] = String(genus))

    sp_s_url = gbifurl * "species/match"
    sp_s_req = HTTP.get(sp_s_url, query=args)
    if sp_s_req.status == 200
        body = JSON.parse(String(sp_s_req.body))
        # This will throw warnings for various reasons related to matchtypes
        matchtype = get(body, "matchType", "WELP...")
        # The first one will catch issues
        if matchtype == "WELP..."
            @warn "Impossible to get information for $(name) at level $(rank)"
            return nothing
        end
        if matchtype == "NONE"
            @warn "No match for $(name) at level $(rank) -- try with strict=false"
            return nothing
        end
        return GBIFTaxon(body)
    else
        @warn "Impossible to retrieve information for $(name) -- HTML error code $(sp_s_req.status)"
        return nothing
    end
    return nothing
end

"""
**Get information about a taxon at any level using taxonID**

    taxon(id::Int)

This function will look for a taxon by its taxonID in the GBIF
reference taxonomy.
"""
function taxon(id::Int)
    args = Dict{String,Any}("id" => id)

    sp_s_url = gbifurl * "species/$id"
    sp_s_req = HTTP.get(sp_s_url, query=args)
    if sp_s_req.status == 200
        body = JSON.parse(String(sp_s_req.body))
        return GBIFTaxon(body)
    else
        throw(ErrorException("Impossible to retrieve information for taxonID $(id) -- HTML error code $(sp_s_req.status)"))
    end

end

taxon(t::Pair) = taxon(t.second)
