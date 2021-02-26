"""
    mosaic(f::TF, layers::Vector{T}) where {TF <: Function, T <: SimpleSDMLayer}

Joins a series of _possibly_ overlapping `layers` by applying the function `f`
to the values that occupy the same cells. Note that the function `f`  should
return a single value and accept an vector as input. Functions like
`Statistics.mean`, etc, work well.

Using `mosaic` with `maximum` is equivalent to `raster::merge` from the *R*
package `raster`.
"""
function mosaic(f::TF, layers::Vector{T}) where {TF <: Function, T <: SimpleSDMLayer}

    # Check the dimensions
    for i in 1:(length(layers)-1)
        for j in 1:length(layers)
            if !(all(stride(layers[i]) .≈ stride(layers[j])))
                throw(DimensionMismatch("Layers $i and $j have different strides"))
            end
        end
    end
    
    # Check the types
    itypes = eltype.(layers)
    if length(unique(itypes)) > 1
        @warn """
        The numeric types of the layers are not unique, this can cause performance issues.
        The returned layer will have $(first(itypes)).
        """
    end
    
    # Get the new bounding boxes
    n_left = minimum([layer.left for layer in layers])
    n_right = maximum([layer.right for layer in layers])
    n_bottom = minimum([layer.bottom for layer in layers])
    n_top = maximum([layer.top for layer in layers])
    
    # Get the gridsize
    nr = round(Int64, (n_top - n_bottom)/2stride(layers[1],1))
    nc = round(Int64, (n_right - n_left)/2stride(layers[1],2))
    
    # Prepare the grid
    grid = fill(nothing, nc, nr)
    grid = convert(Matrix{Union{Nothing,itypes[1]}}, grid)
    L = SimpleSDMResponse(grid, n_left, n_right, n_bottom, n_top)

    stride(L)

    @info n_top - n_bottom
    @info nr
    @info n_right - n_left
    @info nc

    # Fill in the information
    for lat in latitudes(L)
        @info lat
        @info SimpleSDMLayers._match_latitude(L, lat)
        for lon in longitudes(L)
            V = [layer[lon, lat] for layer in layers]
            filter!(!isnothing, V)
            filter!(!isnan, V)
            length(V) == 0 && continue
            @info lon, lat
            L[lon, lat] = convert(itypes[1], f(V))
        end
    end

    # Return
    return T <: SimpleSDMResponse ? L : convert(SimpleSDMPredictor, L)
end