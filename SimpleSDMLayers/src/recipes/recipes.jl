@recipe function plot(layer::T) where {T <: SimpleSDMLayer}
   seriestype --> :heatmap
   @assert eltype(layer) <: Number
   if get(plotattributes, :seriestype, :heatmap) == :heatmap
      x --> longitudes(layer)
      y --> latitudes(layer)
      z --> layer.grid
   elseif get(plotattributes, :seriestype, :histogram) in [:histogram, :density]
      filter(!isnan, layer.grid)
   end
end
