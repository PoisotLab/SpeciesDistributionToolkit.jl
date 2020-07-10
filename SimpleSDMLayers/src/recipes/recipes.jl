"""
test 1
"""
@recipe function plot(layer::T) where {T <: SimpleSDMLayer}
   seriestype --> :heatmap
   if get(plotattributes, :seriestype, :heatmap) in [:heatmap, :contour]
      aspect_ratio --> 1
      xlims --> (minimum(longitudes(layer)),maximum(longitudes(layer)))
      ylims --> (minimum(latitudes(layer)),maximum(latitudes(layer)))
      lg = copy(layer.grid)
      lg[lg.==nothing] .= NaN
      @info type(lg)
      @info eltype(lg)
      @info lg
      longitudes(layer), latitudes(layer), lg
   elseif get(plotattributes, :seriestype, :histogram) in [:histogram, :density]
      filter(!isnothing, layer.grid)
   end
end

"""
test 2
"""
@recipe function plot(l1::FT, l2::ST) where {FT <: SimpleSDMLayer, ST <: SimpleSDMLayer}
   seriestype --> :scatter
   if get(plotattributes, :seriestype, :scatter) in [:scatter, :histogram2d]
      SimpleSDMLayers._layers_are_compatible(l1, l2)
      valid_i = filter(i -> !(isnothing(l1[i])|isnothing(l2[i])), eachindex(l1.grid))
      l1.grid[valid_i], l2.grid[valid_i]
   end
end
