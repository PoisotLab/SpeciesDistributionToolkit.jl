function __demodata()
    datapath = joinpath(dirname(dirname(pathof(SDeMo))), "data")
    y = convert(Vector{Bool}, parse.(Bool, readlines(joinpath(datapath, "labels.csv"))))
    X = parse.(Float64, hcat(split.(readlines(joinpath(datapath, "features.csv")), "\t")...))
    return (permutedims(X), y)
end

@testitem "We can load the demonstration data" begin
    X, y = SDeMo.__demodata()
    @assert length(y) == 1484
    @assert size(X, 2) == length(y)
    @assert size(X, 1) == 19
    @assert eltype(y) <: Bool
    @assert eltype(X) <: Float64
end