function __demodata()
    datapath = joinpath(dirname(dirname(pathof(SDeMo))), "data")
    y = convert(Vector{Bool}, parse.(Bool, readlines(joinpath(datapath, "labels.csv"))))
    X = parse.(Float64, hcat(split.(readlines(joinpath(datapath, "features.csv")), "\t")...))
    return (X, y)
end

@testitem "We can load the demonstration data" begin
    X, y = SDeMo.__demodata()
    @assert length(y) == 1484
    @assert length(X) == (19, 1484)
    @assert eltype(y) isa Bool
    @assert eltype(X) isa Float64
end