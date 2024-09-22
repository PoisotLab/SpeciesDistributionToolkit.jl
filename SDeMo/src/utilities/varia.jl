"""
    iqr(x, m=0.25, M=0.75)

Returns the inter-quantile range, by default between 25% and 75% of
observations.
"""
function iqr(x, m=0.25, M=0.75)
    if all(isnan.(x))
        return 0.0
    else
        return first(diff(quantile(filter(!isnan, x), [m, M])))
    end
end
