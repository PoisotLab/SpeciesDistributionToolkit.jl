import Base: maximum, minimum, sum
import Statistics: mean, median, std

ops = Symbol.(
    "Base.sum", "Base.maximum", "Base.minimum",
    "Statistics.mean", "Statistics.median", "Statistics.std"
    )

for op in ops, ty in (:SimpleSDMResponse, :SimpleSDMPredictor)
    eval(quote
        """
            $($op)(l::$($ty){T}) where {T <: Number}

        Applies `$($op)` to an object of type `$($ty)`. This function has been
        automatically generated. Note that this function is only applied to the
        non-`NaN` elements of the layer, and has no method to work on the
        `dims`; the grid itself can be extracted with `convert(Matrix, l)`.
        """
        function $op(l::$ty{T}) where {T <: Number}
            return $op(filter(!isnan, l.grid))
        end
    end)
end
