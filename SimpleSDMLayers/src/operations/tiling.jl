"""
    tiles(layer::SDMLayer, size::Tuple{Int64,Int64})


"""
function tiles(layer::SDMLayer, s::Tuple{Int64,Int64}=(5,5))
    # Get the cell limits
    eastings = LinRange(layer.x..., size(layer.grid, 2) + 1)
    northings = LinRange(layer.y..., size(layer.grid, 1) + 1)

    # Get the cell splits
    il = floor.(Int, LinRange(1, size(layer, 2) + 1, s[2] + 1))
    jl = floor.(Int, LinRange(1, size(layer, 1) + 1, s[1] + 1))

    layers = Matrix{typeof(layer)}(undef, s)

    # Split
    for i in Base.OneTo(s[2])
        for j in Base.OneTo(s[1])
            grd = layer.grid[jl[j]:(jl[j+1]-1), il[i]:(il[i+1]-1)]
            idx = layer.indices[jl[j]:(jl[j+1]-1), il[i]:(il[i+1]-1)]
            x = (eastings[il[i]], eastings[il[i]+1])
            y = (northings[jl[j]], northings[jl[j]+1])
            layers[j,i] = SDMLayer(grid=grd, indices=idx, x=x, y=y, crs=layer.crs)
        end
    end

    return layers

end