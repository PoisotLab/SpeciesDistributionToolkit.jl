@shorthands bivariate
@shorthands bivariatelegend


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
@recipe function plot(l1::FT, l2::ST; classes::Int=3, p0=colorant"#e8e8e8", p1=colorant"#64acbe", p2=colorant"#c85a5a") where {FT <: SimpleSDMLayer, ST <: SimpleSDMLayer}
    eltype(l1) <: Number || throw(ArgumentError("Plotting is only supported for layers with number values ($(eltype(l1)))"))
    eltype(l2) <: Number || throw(ArgumentError("Plotting is only supported for layers with number values ($(eltype(l2)))"))
    seriestype --> :scatter
    if get(plotattributes, :seriestype, :scatter) in [:scatter, :histogram2d]
        SimpleSDMLayers._layers_are_compatible(l1, l2)
        valid_i = findall(.!isnothing.(l1.grid) .& .!isnothing.(l2.grid))
        l1.grid[valid_i], l2.grid[valid_i]
    elseif get(plotattributes, :seriestype, :bivariate) in [:bivariate]
        SimpleSDMLayers._layers_are_compatible(l1, l2)
        c1 = LinRange(p0, p1, classes)
        c2 = LinRange(p0, p2, classes)
        breakpoints = LinRange(0.0, 1.0, classes+1)
        for i in 2:length(breakpoints)
            m1 = broadcast(v -> breakpoints[i - 1] <= v <= breakpoints[i], l1)
            for j in 2:length(breakpoints)
                m2 = broadcast(v -> breakpoints[j - 1] <= v <= breakpoints[j], l2)
                m = reduce(*, [m1, m2])
                replace!(m, false => nothing)
                @series begin
                    seriescolor := ColorBlendModes.BlendMultiply(c1[i - 1], c2[j - 1])
                    seriestype := :heatmap
                    subplot := 1
                    legend := false
                    convert(Float32, m)
                end
            end
        end
    elseif get(plotattributes, :seriestype, :bivariatelegend) in [:bivariatelegend]
        w, h = 1/classes, 1/classes
        c1 = LinRange(p0, p1, classes)
        c2 = LinRange(p0, p2, classes)
        grid --> :none
        ticks --> :none
        legend --> false
        frametype --> :none
        xlims --> (0,1)
        ylims --> (0,1)
        aspect_ratio --> 1
        for i in 1:classes
            for j in 1:classes
                @series begin
                    seriescolor := BlendMultiply(c1[i], c2[j])
                    seriestype := :shape
                    (i-1)*w .+ [0, w, w, 0], (j-1)*h .+ [0, 0, h, h]
                end
            end
        end
    end
end
