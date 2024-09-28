"""
    tpr(M::ConfusionMatrix)

True-positive rate

``\\frac{TP}{TP+FN}``
"""
tpr(M::ConfusionMatrix) = M.tp / (M.tp + M.fn)

"""
    tnr(M::ConfusionMatrix)

True-negative rate

``\\frac{TN}{TN+FP}``
"""
tnr(M::ConfusionMatrix) = M.tn / (M.tn + M.fp)

"""
    ppv(M::ConfusionMatrix)

Positive predictive value

``\\frac{TP}{TP+FP}``
"""
ppv(M::ConfusionMatrix) = M.tp / (M.tp + M.fp)

"""
    npv(M::ConfusionMatrix)

Negative predictive value

``\\frac{TN}{TN+FN}``
"""
npv(M::ConfusionMatrix) = M.tn / (M.tn + M.fn)

"""
    fnr(M::ConfusionMatrix)

False-negative rate

``\\frac{FN}{FN+TP}``
"""
fnr(M::ConfusionMatrix) = M.fn / (M.fn + M.tp)

"""
    fpr(M::ConfusionMatrix)

False-positive rate

``\\frac{FP}{FP+TN}``
"""
fpr(M::ConfusionMatrix) = M.fp / (M.fp + M.tn)

"""
    fdir(M::ConfusionMatrix)

False discovery rate, 1 - `ppv`
"""
fdir(M::ConfusionMatrix) = 1 - ppv(M)

"""
    fomr(M::ConfusionMatrix)

False omission rate, 1 - `npv`
"""
fomr(M::ConfusionMatrix) = 1 - npv(M)

"""
    plr(M::ConfusionMatrix)

Positive likelihood ratio

``\\frac{TPR}{FPR}``
"""
plr(M::ConfusionMatrix) = tpr(M) / fpr(M)

"""
    nlr(M::ConfusionMatrix)

Negative likelihood ratio

``\\frac{FNR}{TNR}``
"""
nlr(M::ConfusionMatrix) = fnr(M) / tnr(M)

"""
    accuracy(M::ConfusionMatrix)

Accuracy

``\\frac{TP + TN}{TP + TN + FP + FN}``
"""
accuracy(M::ConfusionMatrix) = (M.tp + M.tn) / (M.tp + M.tn + M.fp + M.fn)

"""
    balanced(M::ConfusionMatrix)

Balanced accuracy

``\\frac{1}{2} (TPR + TNR)``
"""
balancedaccuracy(M::ConfusionMatrix) = (tpr(M) + tnr(M)) * 0.5

"""
    f1(M::ConfusionMatrix)

F₁ score, defined as the harmonic mean between precision and recall:

``2\\times\\frac{PPV\\times TPR}{PPV + TPR}``

This uses the more general `fscore` internally.
"""
f1(M::ConfusionMatrix) = fscore(M, 1.0)

"""
    fscore(M::ConfusionMatrix, β=1.0)

Fᵦ score, defined as the harmonic mean between precision and recall, using a
positive factor β indicating the relative importance of recall over precision:

``(1 + \\beta^2)\\times\\frac{PPV\\times TPR}{(\\beta^2 \\times PPV) + TPR}``
"""
fscore(M::ConfusionMatrix, β = 1.0) =
    (1 + β^2.0) * (ppv(M) * tpr(M)) / (β^2.0 * ppv(M) + tpr(M))

"""
    trueskill(M::ConfusionMatrix)

True skill statistic (a.k.a Youden's J, or informedness)

``TPR + TNR - 1``
"""
trueskill(M::ConfusionMatrix) = tpr(M) + tnr(M) - 1.0

"""
    markedness(M::ConfusionMatrix)

Markedness, a measure similar to informedness (TSS) that emphasizes negative
predictions

``PPV + NPV -1``
"""
markedness(M::ConfusionMatrix) = ppv(M) + npv(M) - 1.0

"""
    dor(M::ConfusionMatrix)

Diagnostic odd ratio, defined as `plr`/`nlr`. A useful test has a value larger
than unity, and this value has no upper bound.
"""
dor(M::ConfusionMatrix) = plr(M) / nlr(M)
prevalence(M::ConfusionMatrix) = (M.tp + M.fn) / (M.tp + M.fp + M.tn + M.fn)

"""
    κ(M::ConfusionMatrix)

Cohen's κ
"""
function κ(M::ConfusionMatrix)
    return 2.0 * (M.tp * M.tn - M.fn * M.fp) /
           ((M.tp + M.fp) * (M.fp + M.tn) + (M.tp + M.fn) * (M.fn + M.tn))
end

"""
    mcc(M::ConfusionMatrix)

Matthew's correlation coefficient. This is the default measure of model
performance, and there are rarely good reasons to use anything else to decide
which model to use.
"""
function mcc(M::ConfusionMatrix)
    ret =
        (M.tp * M.tn - M.fp * M.fn) /
        sqrt((M.tp + M.fp) * (M.tp + M.fn) * (M.tn + M.fp) * (M.tn + M.fn))
    return isnan(ret) ? 0.0 : ret
end

function auc(x::Array{T}, y::Array{T}) where {T <: Number}
    S = zero(Float64)
    for i in 2:length(x)
        S += (x[i] - x[i - 1]) * (y[i] + y[i - 1]) * 0.5
    end
    return .-S
end

"""
    ci(C::Vector{ConfusionMatrix}, f)

Applies `f` to all confusion matrices in the vector, and returns the 95% CI.
"""
function ci(C::Vector{ConfusionMatrix}, f)
    v = f.(C)
    return 1.96 * std(v) / sqrt(length(C))
end

"""
    ci(C::Vector{ConfusionMatrix})

Applies the MCC (`mcc`) to all confusion matrices in the vector, and returns the 95% CI.
"""
ci(C::Vector{ConfusionMatrix}) = ci(C, mcc)

crossentropyloss(y, p) = mean(.-(y .* log.(p) .+ (1.0 .- y) .* log.(1.0 .- p)))

"""
    sensitivity(M::ConfusionMatrix)

Alias for `tpr`, the true positive rate
"""
sensitivity(M::ConfusionMatrix) = tpr(M)

"""
    recall(M::ConfusionMatrix)

Alias for `tpr`, the true positive rate
"""
recall(M::ConfusionMatrix) = tpr(M)

"""
    specificity(M::ConfusionMatrix)

Alias for `tnr`, the true negative rate
"""
specificity(M::ConfusionMatrix) = tnr(M)

"""
    precision(M::ConfusionMatrix)

Alias for `ppv`, the positive predictive value
"""
precision(M::ConfusionMatrix) = ppv(M)