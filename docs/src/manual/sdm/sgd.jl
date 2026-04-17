# # Stochastic Gradient Descent

# The purpose of this vignette is to show the key parameters in stochastic
# gradient descent.

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie

# We will work on the demo data:

X, y, C = SDeMo.__demodata();

# The stochastic gradient descent models all use the `SGD` classifier. This is a
# convention borrowed from the `scikit-learn` Python library.

model = SDM(RawData, SGD, X, y, C)

# Using different log functions allow to switch between types of models. The
# default is `:logloss`, which is akin to logistic regression, but it can be
# changed to `:hinge` (equivalent to linear SVM).

hyperparameters!(classifier(model), :loss, :hinge)

# The L1 and L2 loss can be turned on and off:

hyperparameters!(classifier(model), :L1, true)

# The learning rate is the `:η` hyperparameter. It decreases at each epoch, with
# a decay rate of 1 - 10⁻³. The number of epochs (defaults to 5000) is an
# hyper-parameter. The algorithm internally uses samples one at a time, in a
# random update order each epoch.

# The model can be trained with or without an intercept:

hyperparameters!(classifier(model), :intercept, true)

# We can train the model:

train!(model)

# And check its [PR and ROC curves](/manual/sdm/pr-roc/):

thresholds = LinRange(0.01, 0.99, 50)
cv = [crossvalidate(model, montecarlo(model; n = 5); thr = t) for t in thresholds];

#figure pr-sgd-figure
f = Figure()
ax =
    Axis(f[1, 1]; aspect = 1, xlabel = "False positive rate", ylabel = "True positive rate")
scatter!(ax, [fpr(s.validation) for s in cv], [tpr(s.validation) for s in cv])
ax2 = Axis(f[1, 2]; aspect = 1, xlabel = "Precision", ylabel = "Recall")
scatter!(
    ax2,
    [SDeMo.precision(s.validation) for s in cv],
    [SDeMo.recall(s.validation) for s in cv],
)
xlims!(ax, 0.0, 1.0)
ylims!(ax, 0.0, 1.0)
xlims!(ax2, 0.0, 1.0)
ylims!(ax2, 0.0, 1.0)
current_figure() #hide

# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# SDeMo.SGD
# ```
