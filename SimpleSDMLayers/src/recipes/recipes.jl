"""
test 1
"""
@recipe function plot(layer::T) where {T <: SimpleSDMLayer}
    seriestype --> :heatmap
    if get(plotattributes, :seriestype, :heatmap) in [:heatmap, :contour]
        eltype(layer) <: AbstractFloat || throw(ArgumentError("This plot is only supported for layers with number values ($(eltype(layer)))"))
        aspect_ratio --> 1
        xlims --> extrema(longitudes(layer))
        ylims --> extrema(latitudes(layer))
        lg = copy(layer.grid)
        replace!(lg, nothing => NaN)
        lg = convert(Matrix{Float64}, lg)
        longitudes(layer), latitudes(layer), lg
    elseif get(plotattributes, :seriestype, :histogram) in [:histogram, :density]
        collect(layer)
    end
end

"""
test 2
"""
@recipe function plot(l1::FT, l2::ST) where {FT <: SimpleSDMLayer, ST <: SimpleSDMLayer}
    eltype(l1) <: Number || throw(ArgumentError("Plotting is only supported for layers with number values ($(eltype(l1)))"))
    eltype(l2) <: Number || throw(ArgumentError("Plotting is only supported for layers with number values ($(eltype(l2)))"))
    seriestype --> :scatter
    if get(plotattributes, :seriestype, :scatter) in [:scatter, :histogram2d]
        SimpleSDMLayers._layers_are_compatible(l1, l2)
        valid_i = findall(.!isnothing.(l1.grid) .& .!isnothing.(l2.grid))
        l1.grid[valid_i], l2.grid[valid_i]
    end
end
