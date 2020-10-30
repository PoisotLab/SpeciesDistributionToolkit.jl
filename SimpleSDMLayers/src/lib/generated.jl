## Single layer overloads

ops = Dict(
    :Base => [:sum, :maximum, :minimum, :extrema],
    :Statistics => [:mean, :median, :std],
)

for op in ops
    mod = op.first
    if mod != :Base
        eval(quote
            using $mod
        end)
    end
    for fun in op.second
        eval(quote
            import ($mod):($fun)
        end)
        for ty in (:SimpleSDMResponse, :SimpleSDMPredictor)
            eval(
                quote
                    """
                        $($mod).$($fun)(l::$($ty){T}) where {T <: Number}

                    Applies `$($fun)` (from `$($mod)`) to an object of type `$($ty)`. This function has been
                    automatically generated. Note that this function is only applied to the
                    non-`nothing` elements of the layer, and has no method to work on the `dims`
                    keyword; the grid itself can be extracted with `convert(Matrix, l)`.
                    """
                    function $mod.$fun(l::$ty{T}) where {T<:Number}
                        return $mod.$fun(filter(!isnothing, l.grid))
                    end
                end,
            )
        end
    end
end

whole =
    Dict(:Base => [:abs, :sqrt, :log, :log2, :log10, :log1p, :exp, :exp2, :exp10, :expm1])

for op in whole
    mod = op.first
    if mod != :Base
        eval(quote
            using $mod
        end)
    end
    for fun in op.second
        eval(quote
            import ($mod):($fun)
        end)
        for ty in (:SimpleSDMResponse, :SimpleSDMPredictor)
            eval(
                quote
                    """
                        $($mod).$($fun)(l::$($ty){T}) where {T <: Number}

                    Applies `$($fun)` (from `$($mod)`) to every cell within a `$($ty)`, as long as
                    this cell is not `nothing`. This function has been automatically generated.
                    """
                    function $mod.$fun(l::$ty{T}) where {T<:Number}
                        return broadcast($mod.$fun, l)
                    end
                end,
            )
        end
    end
end

## Multiple layers overloads

for fun in (:min, :max, :+, :-, :*, :/)
    mod = :Base
    eval(quote
        import ($mod):($fun)
    end)
    eval(
        quote
            """
                $($mod).$($fun)(l1::SimpleSDMLayer, l2::SimpleSDMLayer)

            Applies `$($fun)` (from `$($mod)`) to every pair of cells from
            two `SimpleSDMLayers` and returns the result as a new `SimpleSDMResponse`
            layer. Note that `$($fun)` is only applied to the pairs without a
            `nothing` element, and returns `nothing` for the pairs with one.
            This function has been automatically generated.
            """
            function $mod.$fun(l1::SimpleSDMLayer, l2::SimpleSDMLayer)
                SimpleSDMLayers._layers_are_compatible(l1, l2)
                nl = similar(l1)
                for i in eachindex(nl.grid)
                    nl.grid[i] = isnothing(l1[i]) || isnothing(l2[i]) ? nothing :
                        $mod.$fun(l1[i], l2[i])
                end
                return nl
            end
        end,
    )
end

for fun in (:mean, :std)
    mod = :Statistics
    eval(quote
        using $mod
    end)
    eval(
        quote
            """
                $($mod).$($fun)(layers::Array{T}) where {T <: SimpleSDMLayer}
            
            Applies `$($fun)` (from `$($mod)`) to the elements in corresponding
            positions from the different layers (similar to
            `mean(a::Array{Matrix})`) and returns the result as a new
            `SimpleSDMResponse` layer. Note that `$($fun)` is only applied to
            the positions  without a `nothing` element and returns `nothing` for
            the pairs with one. This function has been automatically generated.
            """
            function $mod.$fun(layers::Array{T}) where {T<:SimpleSDMLayer}
                SimpleSDMLayers._layers_are_compatible(layers)
                grids = map(x -> x.grid, layers)

                indx_notnothing = findall.(!isnothing, grids)
                unique!(indx_notnothing)
                indx_notnothing = reduce(intersect, indx_notnothing)

                newgrid = Array{Any}(nothing, size(layers[1]))
                newgrid[indx_notnothing] = $mod.$fun(map(x -> x[indx_notnothing], grids))

                internal_types = unique(typeof.(newgrid))
                newgrid = convert(Matrix{Union{internal_types...}}, newgrid)

                return SimpleSDMResponse(newgrid, layers[1])
            end
        end,
    )
end
