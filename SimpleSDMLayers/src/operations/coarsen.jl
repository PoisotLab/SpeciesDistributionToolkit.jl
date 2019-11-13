function coarsen(L::LT, f::FT, d::Tuple{IT,IT}; NaNremove::Bool=true) where {LT <: SimpleSDMLayer, FT <: Function, IT <: Integer}
    cx, cy = d
    CX, CY = size(L)
    # Check that the arguments are compatible with the size of the grid
    mod(CX, cx) == 0 || throw(ArgumentError("The number of cells to aggregate must be compatible with the number of rows"))
    mod(CY, cy) == 0 || throw(ArgumentError("The number of cells to aggregate must be compatible with the number of columns"))
    # Then we create a new grid, full of undefined values of the same type as
    # the elements of L
    nx = convert(Int64, CX/cx)
    ny = convert(Int64, CY/cy)
    # NOTE The union type here is not really pretty, but very much necessary to
    # play nicely with NaN values. This needs to be replaced by a better
    # solution eventually.
    newgrid = Array{Union{eltype(L),Float64},2}(undef, (nx, ny))
    # At this point, we do not need to create the new SimpleSDMLayer object, as
    # it can be a SimpleSDMPredictor which is not mutable. Instead, it is better
    # to work directly on the grid. We will iterate directly on the new grid,
    # and copy information from the old grid as needed.
    for i in 1:size(newgrid, 1)
        old_i = ((i-1)*cx+1):(i*cx)
        for j in 1:size(newgrid, 2)
            old_j = ((j-1)*cy+1):(j*cy)
            V = vec(L.grid[old_i, old_j])
            # If there are NaN to remove, then we call filter!
            !NaNremove || filter!(!isnan, V)
            if length(V) == 0
                # If nothing is left in V, then the grid gets a NaN
                # automatically
                newgrid[i,j] = NaN
            else
                newgrid[i,j] = f(V)
            end
        end
    end
    # Now that everything is done, we can return an object of the same type as L
    return LT(newgrid, L.left, L.right, L.bottom, L.top)
end
