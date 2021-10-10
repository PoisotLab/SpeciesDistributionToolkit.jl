
@shorthands bivariate

@recipe function f(::Type{Val{:bivariate}}, plt::AbstractPlot; classes=3, p0=colorant"#e8e8e8", p1=colorant"#64acbe", p2=colorant"#c85a5a")
    x = plotattributes[:x]
    y = plotattributes[:y]
    println(plotattributes)

    # Get the palettes
    c1 = palette([p0, p1], classes)
    c2 = palette([p0, p2], classes)
    breakpoints = LinRange(0.0, 1.0, classes+1)

    xlims --> extrema(longitudes(x))
    ylims--> extrema(latitudes(x))
    legend --> false
    aspectratio --> 1
    frame --> :box
    subplot --> 1

    for i in 2:length(breakpoints)
        m1 = broadcast(v -> breakpoints[i - 1] <= v <= breakpoints[i], x)
        for j in 2:length(breakpoints)
            m2 = broadcast(v -> breakpoints[j - 1] <= v <= breakpoints[j], y)
            m = reduce(*, [m1, m2])
            replace!(m, false => nothing)
            replace!(m, nothing => NaN)
            @series begin
                seriestype --> :heatmap
                color --> BlendMultiply(c1[i - 1], c2[j - 1])
                longitudes(m), latitudes(m), convert(Matrix{Float64}, m.grid)
            end
        end
    end
end

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
