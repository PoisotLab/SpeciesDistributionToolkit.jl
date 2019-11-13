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

@recipe function plot(l1::T, l2::T) where {T <: SimpleSDMLayer}
   seriestype --> :scatter
   @assert eltype(l1) <: Number
   @assert eltype(l2) <: Number
   @assert size(l1) == size(l2)
   @assert l1.top == l2.top
   @assert l1.left == l2.left
   @assert l1.bottom == l2.bottom
   @assert l1.right == l2.right
   valid_i =filter(i -> !(isnan(l1[i])|isnan(l2[i])), eachindex(l1.grid))
   l1.grid[valid_i], l2.grid[valid_i]
end
