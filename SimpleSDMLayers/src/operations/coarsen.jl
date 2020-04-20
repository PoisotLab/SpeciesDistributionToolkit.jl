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
four cells. By default, the cells containing `nothing` will be *ignored*.
"""
function coarsen(L::LT, f::FT, d::Tuple{IT,IT}) where {LT <: SimpleSDMLayer, FT <: Function, IT <: Integer}
    cx, cy = d
    CX, CY = size(L)
    
    # Check that the arguments are compatible with the size of the grid
    mod(CX, cx) == 0 || throw(ArgumentError("The number of cells to aggregate ($(cx)) must be compatible with the number of rows ($(CX))"))
    mod(CY, cy) == 0 || throw(ArgumentError("The number of cells to aggregate ($(cy)) must be compatible with the number of columns ($(CY))"))
    
    # Then we create a new grid, full of undefined values of the same type as
    # the elements of L
    nx = convert(Int64, CX/cx)
    ny = convert(Int64, CY/cy)
    
    # This is not the best type here, of course, but I'm not sure how to get a
    # better idea _before_.
    newgrid = Array{Any}(undef, (nx, ny))

    # At this point, we do not need to create the new SimpleSDMLayer object, as
    # it can be a SimpleSDMPredictor which is not mutable. Instead, it is better
    # to work directly on the grid. We will iterate directly on the new grid,
    # and copy information from the old grid as needed.
    for i in 1:size(newgrid, 1)
        old_i = ((i-1)*cx+1):(i*cx)
        for j in 1:size(newgrid, 2)
            old_j = ((j-1)*cy+1):(j*cy)
            V = vec(L.grid[old_i, old_j])
    
            # We remove the nothing values from the grid
            filter!(!isnothing, V)

            # If there is nothing left in V, we return nothing -- if not, we return f(V)
            newgrid[i,j] = length(V) == 0 ? nothing : f(V)

        end
    end
    # Now that everything is done, we can return an object of the correct type
    NT = LT <: SimpleSDMPredictor ? SimpleSDMPredictor : SimpleSDMResponse
    return NT(newgrid, L.left, L.right, L.bottom, L.top)
end
