# # Change hyper-parameters

# The purpose of this vignette is to show how the hyper-parameters of models are
# handled by `SDeMo`.

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; px_per_unit = 3) #hide

# We will work on the demo data, using Logistic regression.

X, y = SDeMo.__demodata()

# We will limit the model to two variables for the sake of
# illustration.

sdm = SDM(ZScore, Logistic, X, y)
variables!(sdm, [1, 12])

# We can inspect the hyper-parameters for the transformer:

hyperparameters(transformer(sdm))

# and for the classifier:

hyperparameters(classifier(sdm))

# If we want to turn off the interactions between variables while keeping the
# squared terms, we can use:

hyperparameters!(classifier(sdm), :interactions, :self)
train!(sdm)
SDeMo.__equation(sdm) #hide

# We can similarly tweak the learning rate η (lower is slower but more stable),
# the regularization parameter λ, and the number of epochs used for training.
# For example, if we want slower learning with more penalty for large
# parameters, we can write

hyperparameters!(classifier(sdm), :interactions, :all)
hyperparameters!(classifier(sdm), :η, 1e-4)
hyperparameters!(classifier(sdm), :λ, 0.2)
hyperparameters!(classifier(sdm), :epochs, 10_000)
train!(sdm)
SDeMo.__equation(sdm) #hide

# Note that logistic regression has a `:verbose` hyper-parameter to turn output
# on training epochs on and off.