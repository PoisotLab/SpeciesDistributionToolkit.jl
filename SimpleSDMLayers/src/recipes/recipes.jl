@shorthands bivariate
@shorthands bivariatelegend
@shorthands trivariate
@shorthands trivariatelegend

"""
test 1
"""
@recipe function plot(layer::T) where {T<:SimpleSDMLayer}
    seriestype --> :heatmap
    if get(plotattributes, :seriestype, :heatmap) in [:heatmap, :contour]
        eltype(layer) <: AbstractFloat || throw(
            ArgumentError(
                "This plot is only supported for layers with number values ($(eltype(layer)))",
            ),
        )
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
@recipe function plot(
    l1::FT,
    l2::ST;
    classes::Int=3,
    p0=colorant"#e8e8e8ff",
    p1=colorant"#64acbeff",
    p2=colorant"#c85a5aff",
    quantiles=true,
) where {FT<:SimpleSDMLayer,ST<:SimpleSDMLayer}
    eltype(l1) <: Number || throw(
        ArgumentError(
            "Plotting is only supported for layers with number values ($(eltype(l1)))"
        ),
    )
    eltype(l2) <: Number || throw(
        ArgumentError(
            "Plotting is only supported for layers with number values ($(eltype(l2)))"
        ),
    )
    seriestype --> :scatter
    if get(plotattributes, :seriestype, :scatter) in [:scatter, :histogram2d]
        SimpleSDMLayers._layers_are_compatible(l1, l2)
        valid_i = findall(.!isnothing.(l1.grid) .& .!isnothing.(l2.grid))
        l1.grid[valid_i], l2.grid[valid_i]
    elseif get(plotattributes, :seriestype, :bivariate) in [:bivariate]
        SimpleSDMLayers._layers_are_compatible(l1, l2)
        c1 = LinRange(p0, p1, classes)
        c2 = LinRange(p0, p2, classes)
        breakpoints = LinRange(0.0, 1.0, classes + 1)
        if quantiles
            q1 = rescale(l1, collect(LinRange(0.0, 1.0, 10classes)))
            q2 = rescale(l2, collect(LinRange(0.0, 1.0, 10classes)))
        else
            q1 = rescale(l1, (0.0, 1.0))
            q2 = rescale(l2, (0.0, 1.0))
        end
        classified = similar(l1, Int)
        cols = typeof(p0)[]
        for i in 1:classes
            if isequal(classes)(i)
                fi = (v) -> breakpoints[i] < v <= breakpoints[i + 1]
            else
                fi = (v) -> breakpoints[i] <= v < breakpoints[i + 1]
            end
            m1 = broadcast(fi, q1)
            for j in 1:classes
                if isequal(classes)(j)
                    fj = (v) -> breakpoints[j] < v <= breakpoints[j + 1]
                else
                    fj = (v) -> breakpoints[j] <= v < breakpoints[j + 1]
                end
                m2 = broadcast(fj, q2)
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
        xlims --> (1 - 0.5, classes + 0.5)
        ylims --> (1 - 0.5, classes + 0.5)
        aspect_ratio --> 1
        cols = Vector{typeof(p0)}(undef, classes^2)
        class = 1
        m = zeros(Float64, classes, classes)
        for i in 1:classes
            for j in 1:classes
                m[j, i] = class
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

"""
test 2
"""
@recipe function plot(
    x::FT, y::ST, z::TT; quantiles=true, simplex=false, red="", green="", blue=""
) where {FT<:SimpleSDMLayer,ST<:SimpleSDMLayer,TT<:SimpleSDMLayer}
    eltype(x) <: Number || throw(
        ArgumentError(
            "Plotting is only supported for layers with number values ($(eltype(x)))"
        ),
    )
    eltype(y) <: Number || throw(
        ArgumentError(
            "Plotting is only supported for layers with number values ($(eltype(y)))"
        ),
    )
    eltype(z) <: Number || throw(
        ArgumentError(
            "Plotting is only supported for layers with number values ($(eltype(z)))"
        ),
    )
    SimpleSDMLayers._layers_are_compatible(x, y)
    SimpleSDMLayers._layers_are_compatible(x, z)
    SimpleSDMLayers._layers_are_compatible(y, z)
    seriestype --> :scatter
    if get(plotattributes, :seriestype, :trivariate) in [:trivariate]
        void = colorant"#ffffff00"
        if quantiles
            X = rescale(x, collect(LinRange(0.0, 1.0, 100)))
            Y = rescale(y, collect(LinRange(0.0, 1.0, 100)))
            Z = rescale(z, collect(LinRange(0.0, 1.0, 100)))
        else
            X = rescale(x, (0.0, 1.0))
            Y = rescale(y, (0.0, 1.0))
            Z = rescale(z, (0.0, 1.0))
        end
        trip = fill(void, size(X))
        for i in CartesianIndices(trip)
            if !isnothing(X[i])
                r = X[i]
                g = Y[i]
                b = Z[i]
                if simplex
                    S = r + g + b
                    if S > zero(typeof(S))
                        r = r / S
                        g = g / S
                        b = b / S
                    end
                end
                trip[i] = RGBA(r, g, b, 1.0)
            end
        end
        @series begin
            seriestype := :heatmap
            subplot := 1
            legend --> false
            longitudes(X), latitudes(X), reverse(trip; dims=1)
        end
    elseif get(plotattributes, :seriestype, :trivariatelegend) in [:trivariatelegend]
        # Legend
        steps = 6
        a = 1 / steps
        h = a * sqrt(3) / 2
        aspect_ratio --> 1
        xlims --> (0, 1)
        ylims --> (-0.1, sqrt(3) / 2 + 0.1)
        legend --> false
        ticks --> :none
        framestyle --> :none
        for (row_number, triangles_to_do) in enumerate(reverse(1:steps))
            for triangle_number in 1:triangles_to_do
                x0 = (triangle_number - 1) * a + (row_number - 1) * (a / 2)
                y0 = (row_number - 1) * h
                @series begin
                    subplot := 1
                    seriestype := :shape
                    seriescolor := rgb_from_xy(x0 + a / 2, y0 + h / 2; simplex=simplex)
                    [x0, x0 + a / 2, x0 + a], [y0, y0 + h, y0]
                end
                if row_number > 1
                    @series begin
                        subplot := 1
                        seriestype := :shape
                        seriescolor := rgb_from_xy(x0 + a / 2, y0 - h / 2; simplex=simplex)
                        [x0, x0 + a / 2, x0 + a], [y0, y0 - h, y0]
                    end
                end
            end
        end
        @series begin
            seriestype := :scatter
            annotations := [(0.0, -0.05, red, :center), (1.0, -0.05, green, :center), (0.5, sqrt(3)/2+0.05, blue, :center)]
            markersize := 0
            [0.0, 0.0]
        end
    end
end

function rgb_from_xy(x, y; simplex=false)
    b = 2y / sqrt(3)
    g = (2x - b) / 2
    r = 1 - (b + g)
    if !simplex
        m = maximum([r, g, b])
        b = b * (1 / m)
        g = g * (1 / m)
        r = r * (1 / m)
    end
    return RGB(r, g, b)
end
