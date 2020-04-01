import Base: maximum, minimum
import Statistics: mean, median, std

ops = ("Base.maximum", "Base.minimum", "Statistics.mean", "Statistics.median", "Statistics.std")

for op in Symbol.(ops), ty in (:SimpleSDMResponse, :SimpleSDMPredictor)
    eval(quote
        function $op(l::$ty{T}) where {T <: Number}
            return $op(filter(!isnan, l.grid))
        end
    end)
end
