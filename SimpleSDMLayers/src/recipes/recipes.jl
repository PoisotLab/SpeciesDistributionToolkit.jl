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
        classified = similar(l1, Int)
        cols = typeof(p0)[]
        for i in 1:classes
            if isequal(classes)(i)
                fi = (v) -> breakpoints[i] < v <= breakpoints[i+1]
            else
                fi = (v) -> breakpoints[i] <= v < breakpoints[i+1]
            end
            m1 = broadcast(fi, l1)
            for j in 1:classes
                if isequal(classes)(j)
                    fj = (v) -> breakpoints[j] < v <= breakpoints[j+1]
                else
                    fj = (v) -> breakpoints[j] <= v < breakpoints[j+1]
                end
                m2 = broadcast(fj, l2)
                push!(cols, ColorBlendModes.BlendMultiply(c1[i], c2[j]))
                m = reduce(*, [m1, m2])
                replace!(m, false => nothing)
                if length(m) > 0
                    classified[keys(m)] = fill(length(cols), length(m))
                end
            end
        end
        replace!(classified, 0 => 1)
        @series begin
            seriescolor := vec(cols)
            seriestype := :heatmap
            subplot := 1
            legend --> false
            clims --> (1, classes^2)
            convert(Float16, classified)
        end
    elseif get(plotattributes, :seriestype, :bivariatelegend) in [:bivariatelegend]
        c1 = LinRange(p0, p1, classes)
        c2 = LinRange(p0, p2, classes)
        grid --> :none
        ticks --> :none
        legend --> false
        frametype --> :none
        xlims --> (1-0.5, classes+0.5)
        ylims --> (1-0.5, classes+0.5)
        aspect_ratio --> 1
        cols = Vector{typeof(p0)}(undef, classes^2)
        class = 1
        m = zeros(Float64, classes, classes)
        for i in 1:classes
            for j in 1:classes
                m[j,i] = class
                cols[class] = ColorBlendModes.BlendMultiply(c1[i], c2[j])
                class += 1
            end
        end
        @series begin
            seriescolor := cols
            seriestype := :heatmap
            m
        end
    end
end
