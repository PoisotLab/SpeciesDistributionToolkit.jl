import Base: maximum, minimum
import Statistics: mean, median, std

ops = ["Base.maximum", "Base.minimum", "Statistics.mean", "Statistics.median", "Statistics.std"]

for op = Symbol.(ops)
    for ty in [:SimpleSDMPredictor, :SimpleSDMResponse]
        eval(quote
            """
                $op(l::$ty{T,K}) where {T <: Number, K <: AbstractFloat}

            Overload of `$op` for objects of type $ty - this applies $op to the
            non-NaN elements of the `grid`.
            """
            function $op(l::$ty{T}) where {T <: Number}
                return $op(filter(!isnan, l.grid))
            end
        end)
    end
end
