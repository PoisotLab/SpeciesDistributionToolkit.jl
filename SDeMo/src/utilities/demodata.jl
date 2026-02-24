"""
    __demodata()

Presence and pseudo-absence dataset dervied from observations of *Sitta
whiteheadi* in Corsica.

The GBIF DOI for the observations is 10.15468/dl.aefk4v

The 19 predictors are BioClim variables from CHELSA2.

This returns three things: the feature matrix `X`, the vector of labels `y`, and
finally a vector of tuples that contain the lon,lat coordinates.
"""
function __demodata()
    datapath = joinpath(dirname(dirname(pathof(SDeMo))), "data")
    y = convert(Vector{Bool}, parse.(Bool, readlines(joinpath(datapath, "labels.csv"))))
    X = parse.(Float64, hcat(split.(readlines(joinpath(datapath, "features.csv")), "\t")...))
    C = [tuple(line) for line in readlines(joinpath(datapath, "coordinates.csv"))]
    return (permutedims(X), y, C)
end

@testitem "We can load the demonstration data, and they contain the coordinates for each instance" begin
    X, y, C = SDeMo.__demodata()
    @assert length(y) == 1484
    @assert length(C) == length(y)
    @assert size(X, 2) == length(y)
    @assert size(X, 1) == 19
    @assert eltype(y) <: Bool
    @assert eltype(X) <: Float64
    @assert eltype(C) <: Tuple{Float64, Float64}
end