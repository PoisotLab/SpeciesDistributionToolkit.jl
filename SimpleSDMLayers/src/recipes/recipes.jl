"""
test 1
"""
@recipe function plot(layer::T) where {T <: SimpleSDMLayer}
   seriestype --> :heatmap
   @assert eltype(layer) <: Number
   if get(plotattributes, :seriestype, :heatmap) == :heatmap
      aspect_ratio --> 1
      longitudes(layer), latitudes(layer), layer.grid
   elseif get(plotattributes, :seriestype, :histogram) in [:histogram, :density]
      filter(!isnan, layer.grid)
   end
end

"""
test 2
"""
@recipe function plot(l1::FT, l2::ST) where {FT <: SimpleSDMLayer, ST <: SimpleSDMLayer}
   seriestype --> :scatter
   if get(plotattributes, :seriestype, :scatter) in [:scatter, :histogram2d]
      @assert eltype(l1) <: Number
      @assert eltype(l2) <: Number
      SimpleSDMLayers.are_compatible(l1, l2)
      valid_i =filter(i -> !(isnan(l1[i])|isnan(l2[i])), eachindex(l1.grid))
      l1.grid[valid_i], l2.grid[valid_i]
   end
end
