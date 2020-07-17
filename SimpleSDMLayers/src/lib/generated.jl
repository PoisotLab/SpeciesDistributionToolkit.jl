ops = Dict(
    :Base => [:sum, :maximum, :minimum, :extrema],
    :Statistics => [:mean, :median, :std]
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
            import $mod: $fun
        end)
        for ty in (:SimpleSDMResponse, :SimpleSDMPredictor)
            eval(quote
            """
                $($mod).$($fun)(l::$($ty){T}) where {T <: Number}

            Applies `$($fun)` (from `$($mod)`) to an object of type `$($ty)`. This function has been
            automatically generated. Note that this function is only applied to the
            non-`nothing` elements of the layer, and has no method to work on the `dims`
            keyword; the grid itself can be extracted with `convert(Matrix, l)`.
            """
            function $mod.$fun(l::$ty{T}) where {T <: Number}
                return $mod.$fun(filter(!isnothing, l.grid))
            end
            end)
        end
    end
end

whole = Dict(
    :Base => [:abs, :sqrt, :log, :log2, :log10, :log1p, :exp, :exp2, :exp10, :expm1]
)

for op in whole
    mod = op.first
    if mod != :Base
        eval(quote
            using $mod
        end)
    end
    for fun in op.second
        eval(quote
            import $mod: $fun
        end)
        for ty in (:SimpleSDMResponse, :SimpleSDMPredictor)
            eval(quote
            """
                $($mod).$($fun)(l::$($ty){T}) where {T <: Number}

            Applies `$($fun)` (from `$($mod)`) to every cell wihtin a `$($ty)`, as long as
            this cell is not `nothing`. This function has been automatically generated.
            """
            function $mod.$fun(l::$ty{T}) where {T <: Number}
                return broadcast($mod.$fun, l)
            end
            end)
        end
    end
end
