"""
    Phylopic.imagesof(taxon::GBIF.GBIFTaxon; kwargs...)

Performs a search in phylopic for a given GBIF taxon object, walking from the lowermost taxonomic level up to the top. This is not guaranteed to give the best results.
"""
function Phylopic.imagesof(tax::GBIF.GBIFTaxon; kwargs...)
    for rank in [:species, :genus, :family, :order, :class, :phylum, :kingdom]
        if ~ismissing(getfield(tax, rank))
            rankinfo = getfield(tax, rank)
            phylopic_matches = Phylopic.imagesof(rankinfo.first; kwargs...)
            if ~isnothing(phylopic_matches)
                return phylopic_matches
            end
        end
    end
    return nothing
end
