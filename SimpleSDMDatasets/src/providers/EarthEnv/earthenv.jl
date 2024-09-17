EarthEnvDataset = Union{LandCover, HabitatHeterogeneity}
provides(::Type{EarthEnv}, ::Type{T}) where {T <: EarthEnvDataset} = true

blurb(::Type{EarthEnv}) = "https://www.earthenv.org/"
blurb(::Type{EarthEnv}) = md"""
The EarthEnv project is a collaborative project of biodiversity scientists and
remote sensing experts to develop near-global standardized, 1km resolution
layers for monitoring and modeling biodiversity, ecosystems, and climate. The
work is supported by NCEAS, NASA, NSF, and Yale University.
"""