rangediff(new, old) = mask(new .| old, new .- old)

function iqr(x)
    if all(isnan.(x))
        return 0.0
    else
        return first(diff(quantile(filter(!isnan, x), [0.25, 0.75])))
    end
end
