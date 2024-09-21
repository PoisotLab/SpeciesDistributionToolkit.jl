function noskill(labels::Vector{Bool})
    p = mean(labels)
    tp = p^2
    tn = (1 - p)^2
    fp = p * (1 - p)
    fn = (1 - p) * p
    return ConfusionMatrix(tp, tn, fp, fn)
end

function coinflip(labels::Vector{Bool})
    p = mean(labels)
    tp = 1 / 2 * p
    tn = 1 / 2 * p
    fp = 1 / 2 * (1 - p)
    fn = 1 / 2 * (1 - p)
    return ConfusionMatrix(tp, tn, fp, fn)
end

function constantpositive(labels::Vector{Bool})
    p = mean(labels)
    tp = p
    tn = 0.
    fp = (1 - p)
    fn = 0.
    return ConfusionMatrix(tp, tn, fp, fn)
end

function constantnegative(labels::Vector{Bool})
    p = mean(labels)
    tp = 0.
    tn = (1 - p)
    fp = 0.
    fn = p
    return ConfusionMatrix(tp, tn, fp, fn)
end