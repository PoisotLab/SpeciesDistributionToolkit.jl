EarthEnvDataset = Union{LandCover, HabitatHeterogeneity}
provides(::Type{EarthEnv}, ::Type{T}) where {T <: EarthEnvDataset} = true