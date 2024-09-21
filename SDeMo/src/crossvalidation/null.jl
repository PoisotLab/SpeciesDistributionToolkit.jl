"""
    noskill(labels::Vector{Bool})

Returns the confusion matrix for the no-skill classifier given a vector of
labels. Predictions are made at random, with each class being selected by its
proportion in the training data.
"""
function noskill(labels::Vector{Bool})
    p = mean(labels)
    tp = p^2
    tn = (1 - p)^2
    fp = p * (1 - p)
    fn = (1 - p) * p
    return ConfusionMatrix(tp, tn, fp, fn)
end

"""
    coinflip(labels::Vector{Bool})

Returns the confusion matrix for the no-skill classifier given a vector of
labels. Predictions are made at random, with each class being selected with a
probability of one half.
"""
function coinflip(labels::Vector{Bool})
    p = mean(labels)
    tp = 1 / 2 * p
    tn = 1 / 2 * p
    fp = 1 / 2 * (1 - p)
    fn = 1 / 2 * (1 - p)
    return ConfusionMatrix(tp, tn, fp, fn)
end

"""
    constantpositive(labels::Vector{Bool})

Returns the confusion matrix for the constant positive classifier given a vector
of labels. Predictions are assumed to always be positive.
"""
function constantpositive(labels::Vector{Bool})
    p = mean(labels)
    tp = p
    tn = 0.0
    fp = (1 - p)
    fn = 0.0
    return ConfusionMatrix(tp, tn, fp, fn)
end

"""
    constantnegative(labels::Vector{Bool})

Returns the confusion matrix for the constant positive classifier given a vector
of labels. Predictions are assumed to always be negative.
"""
function constantnegative(labels::Vector{Bool})
    p = mean(labels)
    tp = 0.0
    tn = (1 - p)
    fp = 0.0
    fn = p
    return ConfusionMatrix(tp, tn, fp, fn)
end

for nullclass in (:noskill, :coinflip, :constantpositive, :constantnegative)
    eval(quote
        """
            $op(sdm::SDM)

        Version of `$op` using the training labels for an SDM.
        """
        $op(sdm::SDM) = $op(labels(sdm))
    end)
end