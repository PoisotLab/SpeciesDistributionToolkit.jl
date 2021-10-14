@shorthands bivariate
@shorthands bivariatelegend
@shorthands trivariate
@shorthands trivariatelegend

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
@recipe function plot(l1::FT, l2::ST; classes::Int=3, p0=colorant"#e8e8e8ff", p1=colorant"#64acbeff", p2=colorant"#c85a5aff", quantiles=true) where {FT <: SimpleSDMLayer, ST <: SimpleSDMLayer}
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
        if quantiles
            q1 = rescale(l1, collect(LinRange(0.0, 1.0, 10classes)))
            q2 = rescale(l2, collect(LinRange(0.0, 1.0, 10classes)))
        else
            q1 = rescale(l1, (0., 1.))
            q2 = rescale(l2, (0., 1.))
        end
        classified = similar(l1, Int)
        cols = typeof(p0)[]
        for i in 1:classes
            if isequal(classes)(i)
                fi = (v) -> breakpoints[i] < v <= breakpoints[i+1]
            else
                fi = (v) -> breakpoints[i] <= v < breakpoints[i+1]
            end
            m1 = broadcast(fi, q1)
            for j in 1:classes
                if isequal(classes)(j)
                    fj = (v) -> breakpoints[j] < v <= breakpoints[j+1]
                else
                    fj = (v) -> breakpoints[j] <= v < breakpoints[j+1]
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


"""
test 2
"""
@recipe function plot(x::FT, y::ST, z::TT; quantiles=true, simplex=false, red="", green="", blue="") where {FT <: SimpleSDMLayer, ST <: SimpleSDMLayer, TT <: SimpleSDMLayer}
    eltype(x) <: Number || throw(ArgumentError("Plotting is only supported for layers with number values ($(eltype(x)))"))
    eltype(y) <: Number || throw(ArgumentError("Plotting is only supported for layers with number values ($(eltype(y)))"))
    eltype(z) <: Number || throw(ArgumentError("Plotting is only supported for layers with number values ($(eltype(z)))"))
    SimpleSDMLayers._layers_are_compatible(x, y)
    SimpleSDMLayers._layers_are_compatible(x, z)
    SimpleSDMLayers._layers_are_compatible(y, z)
    seriestype --> :scatter
    if get(plotattributes, :seriestype, :trivariate) in [:trivariate]
        void = colorant"#ffffff00"
        if quantiles
            X = rescale(x, collect(LinRange(0.0, 1.0, 256)))
            Y = rescale(y, collect(LinRange(0.0, 1.0, 256)))
            Z = rescale(z, collect(LinRange(0.0, 1.0, 256)))
        else
            X = rescale(x, (0., 1.))
            Y = rescale(y, (0., 1.))
            Z = rescale(z, (0., 1.))
        end
        trip = fill(void, size(X))
        for i in CartesianIndices(trip)
            if !isnothing(X[i])
                r = X[i]
                g = Y[i]
                b = Z[i]
                if simplex
                    S = r+g+b
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
    end
end


function _sunflower(n, α)
    b = round(α*sqrt(n))
    ϕ = (sqrt(5)+1)/2
    r = zeros(Float64, n)
    θ = zeros(Float64, n)
    for k in 1:n
        r[k] = k>(n-b) ? 1.0 : sqrt(k-1/2)/sqrt(n-(b+1)/2)
        θ[k] = 2π*k/ϕ^2
    end
    x = r.*cos.(θ)
    y = r.*sin.(θ)
    return (x, y)
end


#=
saturation = 0.9
rad = atan.(x0, y0)
deg = rad * (180. / π)

c = HSV.(deg, saturation, 0.8.*sqrt.(x0.*x0 .+ y0.*y0))
nr, ng, nb = layernames(WorldClim, BioClim, [1,3,12])

plot(; aspectratio=1, xlim=, ylim=(-1.3,1.3), grid=false, leg=false, frame=:none)
scatter!(x0, y0, c=c, aspectratio=1, msw=1.0, ms=4)



ax, ay = R * cos(π/2), R * sin(π/2)
annotate!(ax, ay, Plots.text(nr, 10, :dark, rotation = 0))

ax, ay = R * cos(3π/2+π/3), R * sin(3π/2+π/3)
annotate!(ax, ay, Plots.text(ng, 10, :dark, rotation = 60))

ax, ay = R * cos(π/2+2π/3), R * sin(π/2+2π/3)
annotate!(ax, ay, Plots.text(nb, 10, rotation = -60))
=#