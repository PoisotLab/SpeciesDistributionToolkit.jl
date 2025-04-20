"""
    PhylopicSilhouette

The two fields are the name and the UUID - we can do everything we need form
there.
"""
struct PhylopicSilhouette
    name::String
    id::Base.UUID
end

PhylopicSilhouette(p::Pair{String, Base.UUID}) = PhylopicSilhouette(p.first, p.second)