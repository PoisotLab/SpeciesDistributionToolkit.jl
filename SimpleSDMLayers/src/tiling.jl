"""
    tiles(layer::SDMLayer, size::Tuple{Int64,Int64})


"""
function tiles(layer::SDMLayer, s::Tuple{Int64,Int64})
    # Get the cell limits
    eastings = LinRange(layer.x..., size(layer.grid, 2) + 1)
    northings = LinRange(layer.y..., size(layer.grid, 1) + 1)

    # Get the cell splits
    il = floor.(Int, LinRange(1, size(layer, 1) + 1, s[1] + 1))
    jl = floor.(Int, LinRange(1, size(layer, 2) + 1, s[2] + 1))

    layers = Matrix{typeof(layer)}(undef, s)

    # Split
    for i in Base.OneTo(s[1])
        for j in Base.OneTo(s[2])
            grd = layer.grid[il[i]:(il[i+1]-1), jl[j]:(jl[j+1]-1)]
            x = (eastings[il[i]], eastings[il[i]+1])
            y = (northings[jl[j]], northings[jl[j]+1])
            layers[i,j] = SDMLayer(grid=grd, nodata=layer.nodata, x=x, y=y, crs=layer.crs)
        end
    end

    return layers

end