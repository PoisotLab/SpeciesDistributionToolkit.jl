"""
    coarsen(L::LT, f::FT, d::Tuple{IT,IT}; NaNremove::Bool=true) where {LT <: SimpleSDMLayer, FT <: Function, IT <: Integer}

This function will *aggregate* a layer by merging cells. The function `f` passed
as its second argument is expected to take an array as input, and return a
single value of the same type as the values of the layer, or as a floating point
value. Note that the element type of the returned layer will have type `Any`,
which is not really pretty, but should serve well enough (and can be changed by
working on the `grid` field directly if you really need it).

The size of the cells to aggregate is given by the tuple, so that `(2,2)` will
make groups of two cells vertically and two cells horizontally, for a total of
four cells.

The `NaNremove` keyword argument is intended to remove `NaN` values before
applying `f`. It defaults to `true`.
"""
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
            # If there are NaN to remove, then we call filter!. NaN only make
            # sense if the type of the elements of V is a floating point, so we
            # need to do an additional check to only apply this whenever there
            # are floating point elements:
            !NaNremove || filter!(x -> typeof(x)<:AbstractFloat ? !isnan(x) : true, V)
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
